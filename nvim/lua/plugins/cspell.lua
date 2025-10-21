return {
  'ryu-ichiroh/vim-cspell',
  cond = function()
    return vim.fn.executable('cspell') == 1
  end,
}
