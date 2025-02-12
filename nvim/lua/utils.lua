-- utils
local function map(lhs, rhs, desc, opts)
  local options = { desc = desc }
  for k, v in ipairs(opts or {}) do
    options[k] = v
  end
  vim.keymap.set(opts.mode, lhs, rhs, options)
end

function nmap(lhs, rhs, desc) map(lhs, rhs, desc, { mode = 'n' }) end

-- Helper function to find the project root
local function find_project_root(root_patterns)
  local current_file = vim.fn.expand('%:p')
  local root = vim.fn.finddir(root_patterns[1], current_file .. ';')

  for _, pattern in ipairs(root_patterns) do
    local found = vim.fn.finddir(pattern, current_file .. ';')
    if found ~= '' then
      root = found
      break
    end
  end

  if root == '' then
    return vim.fn.getcwd() -- Fallback to current working directory
  end

  return vim.fn.fnamemodify(root, ':h')
end

return {
  find_project_root = find_project_root
}
