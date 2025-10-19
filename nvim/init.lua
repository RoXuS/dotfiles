local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- vim.lsp.set_log_level("debug")

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- globals
command = vim.api.nvim_create_user_command
ag = vim.api.nvim_create_augroup
au = vim.api.nvim_create_autocmd

require "utils"
require "keymaps"
require "options"

require("lazy").setup({
  { import = "plugins" }
})
