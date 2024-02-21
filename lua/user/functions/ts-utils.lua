local M = {}

---Loops through all parent nodes to find the closest function or method declaration
---@param node TSNode
---@return TSNode|nil
M.find_closest_function = function(node)
  while node ~= nil do
    local type = node:type()
    if type == "function_declaration" or type == "method_declaration" or type == "func_literal" then
      break
    end

    node = node:parent()
  end

  return node
end

---Finds the group of tab characters at the start of the node's line
---@param node TSNode
---@return string
M.get_identation = function(node)
  local curr_line = node:start()
  local next_line = curr_line + 1

  local line = vim.api.nvim_buf_get_lines(0, curr_line, next_line, false)[1]
  local identation = string.match(line, "^\t+")

  if identation == nil then
    return ""
  end

  return identation
end

return M
