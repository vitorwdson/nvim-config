local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("user.functions.ts-utils")

local mason_bin_folder = vim.fn.stdpath('data') .. "/mason/bin"
local sql_formatter_cmd = {
  mason_bin_folder .. "/sql-formatter",
  "-c",
  vim.fn.stdpath("config") .. "/sql-formatter.json",
}

local file_path = vim.fn.stdpath("config") .. "/queries/go/injections.scm"
local file = io.open(file_path, "r")
if file == nil then
  return
end

local language = ts.language.get_lang("go")
if language == nil then
  return
end

local query_string = file:read("*a")
local query = ts.query.parse(language, query_string)

---@param node TSNode
local function run_formatter(node)
  local start_line, start_col, end_line, end_col = node:range()
  local unformatted_text = vim.api.nvim_buf_get_text(
    0,
    start_line,
    start_col + 1,
    end_line,
    end_col - 1,
    {}
  )
  local formatted_text = {}
  local errors = { "Error formatting SQL strings: " }

  local job = vim.fn.jobstart(sql_formatter_cmd, {
    on_stdout = function(job_id, data, name)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(formatted_text, line)
        end
      end
    end,

    on_stderr = function(job_id, data, name)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(errors, line)
        end
      end
    end,

    on_exit = function(job_id, exit_code, event_type)
      if exit_code ~= 0 then
        error(table.concat(errors, "\n"))
        return
      end

      local identation = ts_utils.get_identation(node)
      for i, line in ipairs(formatted_text) do
        formatted_text[i] = identation .. "\t" .. line
      end

      table.insert(formatted_text, 1, "")
      table.insert(formatted_text, identation)

      vim.api.nvim_buf_set_text(
        0,
        start_line,
        start_col + 1,
        end_line,
        end_col - 1,
        formatted_text
      )
    end,
  })

  vim.fn.chansend(job, unformatted_text)
  vim.fn.chanclose(job, "stdin")
end

local function format_go_sql()
  -- Get the current buffer's parser
  local parser = parsers.get_parser()
  if parser == nil then
    return
  end

  -- Ignore if not in a go file
  local lang = parser:lang()
  if lang ~= "go" then
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  ---@diagnostic disable-next-line: missing-parameter
  for id, node, _ in query:iter_captures(root, 0) do
    local name = query.captures[id]

    if name == "injection.content" then
      run_formatter(node)
    end
  end
end

-- vim.api.nvim_create_user_command(
--   "FormatGoSQL",
--   format_go_sql,
--   { desc = "Formats SQL strings inside go files" }
-- )
