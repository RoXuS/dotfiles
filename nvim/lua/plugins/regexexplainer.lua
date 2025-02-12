return {
  'bennypowers/nvim-regexplainer',
  config = function() require 'regexplainer'.setup() end,
  requires = {
    'nvim-treesitter/nvim-treesitter',
    'MunifTanjim/nui.nvim',
  }
}
