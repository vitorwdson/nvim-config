local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("user.functions.ts-utils")

-- Get all return types for a function/method
local query_string = [[
(_
  result: [
    (type_identifier) @type
    (pointer_type) @type
    (parameter_list
      (parameter_declaration
        type: [
          (type_identifier)
          (pointer_type)
          (slice_type)
        ] @type ))])
]]

-- Return values by data type
local type_values = {
  int = "0",
  int8 = "0",
  int16 = "0",
  int32 = "0",
  int64 = "0",
  float32 = "0.0",
  flint64 = "0.0",
  string = '""',
  bool = 'false',
  error = 'err',
}

local function insert_go_error_handling()
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

  local curr_node = ts.get_node()
  if curr_node == nil then
    return
  end

  local next_line = vim.api.nvim_win_get_cursor(0)[1]
  local assignment = ts_utils.find_closest_assignment(curr_node)
  if assignment ~= nil then
    next_line = ts.get_range(assignment, 0)[4] + 1
  end

  local function_node = ts_utils.find_closest_function(curr_node)
  if function_node == nil then
    return
  end

  local query = ts.query.parse(lang, query_string)
  local return_values = {}

  ---@diagnostic disable-next-line: missing-parameter
  for _, node, _ in query:iter_captures(function_node, 0) do
    local type = ts.get_node_text(node, 0)
    local value = type_values[type]

    print(type, value)

    -- If the type is not in the type_values table it's probably a struct or an interface
    if not value then
      if string.sub(type, 1, 1) == "*" then
        value = "nil"
      elseif string.sub(type, 1, 3) == "map" then
        value = "nil"
      elseif string.sub(type, 1, 2) == "[]" then
        value = "nil"
      else
        value = type .. "{}"
      end
    end

    table.insert(return_values, value)
  end

  local identation = ts_utils.get_identation(curr_node)
  local function_identation = ts_utils.get_identation(function_node)

  -- Fixes identation if the cursor is at the function definition
  if string.len(function_identation) == string.len(identation) then
    identation = identation .. "\t"
  end

  -- Writes the error handling to the buffer on the line below the cursor
  local return_string = table.concat(return_values, ", ")
  vim.api.nvim_buf_set_lines(0, next_line, next_line, false, {
    identation .. "if err != nil {",
    identation .. "\treturn " .. return_string,
    identation .. "}"
  })
end

vim.keymap.set("n", "<leader>ger", insert_go_error_handling)
