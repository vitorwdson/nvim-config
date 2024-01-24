local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")

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
        ] @type ))])
]]

-- Return values by data type (nil for whatever is not here)
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

---Loops through all parent nodes to find the closest function or method declaration
---@param node TSNode
---@return TSNode|nil
local function find_closest_function(node)
  while node ~= nil do
    local type = node:type()
    if type == "function_declaration" or type == "method_declaration" then
      break
    end

    node = node:parent()
  end

  return node
end

---Finds the group of tab characters at the start of the node's line
---@param node TSNode
---@return string
local function get_identation(node)
  local curr_line = node:start()
  local next_line = curr_line + 1

  local line = vim.api.nvim_buf_get_lines(0, curr_line, next_line, false)[1]
  local identation = string.match(line, "^\t+")

  if identation == nil then
    return ""
  end

  return identation
end

local function insert_go_error_handling()
  -- Get the current buffer's parser
  local parser = parsers.get_parser()

  -- Ignore if not in a go file
  local lang = parser:lang()
  if lang ~= "go" then
    return
  end

  local curr_node = ts.get_node()
  if curr_node == nil then
    return
  end

  -- TODO: Check if the current line starts a multi-line block (e.g. a function call)
  -- and adds the error handling after it ends
  local next_line = curr_node:start() + 1

  local function_node = find_closest_function(curr_node)
  if function_node == nil then
    return
  end

  local query = ts.query.parse(lang, query_string)
  local return_values = {}

  ---@diagnostic disable-next-line: missing-parameter
  for _, node, _ in query:iter_captures(function_node, 0) do
    local type = ts.get_node_text(node, 0)
    local value = type_values[type]

    -- If the type is not in the type_values table, return nil
    if not value then
      -- TODO: Maybe return an empty struct if the value is not a pointer?
      value = 'nil'
    end

    table.insert(return_values, value)
  end

  local identation = get_identation(curr_node)
  local function_identation = get_identation(function_node)

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

vim.keymap.set("n", "<leader>err", insert_go_error_handling)
