local ts = vim.treesitter
local ts_utils = require("user.functions.ts-utils")

local sql_formatter_cmd = {
  "sql-formatter",
  "-c",
  vim.fn.stdpath("config") .. "/sql-formatter.json",
}

if not vim.fn.executable("sql-formatter") then
  local mason_bin_folder = vim.fn.stdpath("data") .. "/mason/bin"
  sql_formatter_cmd[1] = mason_bin_folder .. "/sql-formatter"
end

---@type TSQuery|nil
local query = nil
---@return TSQuery | nil
local load_query = function()
  local file_path = vim.fn.stdpath("config") .. "/queries/go/injections.scm"
  local file = io.open(file_path, "r")
  if file == nil then
    return nil
  end

  local language = ts.language.get_lang("go")
  if language == nil then
    return nil
  end

  local query_string = file:read("*a")
  query = ts.query.parse(language, query_string)

  return query
end

---@param node TSNode
---@return integer
local function run_formatter(node)
  local start_line, start_col, end_line, end_col = node:range()
  local unformatted_text = vim.api.nvim_buf_get_text(0, start_line, start_col + 1, end_line, end_col - 1, {})
  print(vim.inspect(unformatted_text))
  local formatted_text = {}
  local errors = { "Error formatting SQL strings: " }

  local job = vim.fn.jobstart(sql_formatter_cmd, {
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(formatted_text, line)
        end
      end
    end,

    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(errors, line)
        end
      end
    end,

    on_exit = function(_, exit_code, _)
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

      vim.api.nvim_buf_set_text(0, start_line, start_col + 1, end_line, end_col - 1, formatted_text)
    end,
  })

  vim.fn.chansend(job, unformatted_text)
  vim.fn.chanclose(job, "stdin")
  local result = vim.fn.jobwait({ job }, 1000)
  return result[1]
end

local function format_go_sql()
  -- Get the current buffer's parser
  local parser = vim.treesitter.get_parser()
  if parser == nil then
    return
  end

  -- Ignore if not in a go file
  local lang = parser:lang()
  if lang ~= "go" then
    return
  end

  if query == nil then
    load_query()
  end

  if query == nil then
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  ---@type TSNode[]
  local captured_nodes = {}

  ---@diagnostic disable-next-line: missing-parameter
  for id, node, _ in query:iter_captures(root, 0) do
    local name = query.captures[id]

    if name == "injection.content" then
      table.insert(captured_nodes, node)
    end
  end

  for i = #captured_nodes, 1, -1 do
    local node = captured_nodes[i]
    local code = run_formatter(node)
    if code ~= 0 then
      break
    end
  end
end

vim.api.nvim_create_user_command("FormatGoSQL", format_go_sql, { desc = "Formats SQL strings inside go files" })
