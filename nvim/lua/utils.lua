-- utils
local function map(lhs, rhs, desc, opts)
  local options = { desc = desc }
  for k, v in ipairs(opts or {}) do
    options[k] = v
  end
  vim.keymap.set(opts.mode, lhs, rhs, options)
end

function nmap(lhs, rhs, desc) map(lhs, rhs, desc, { mode = 'n' }) end
