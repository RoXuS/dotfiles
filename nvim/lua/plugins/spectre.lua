# Search and replace
return {
  'nvim-pack/nvim-spectre',
  config = function()
    require('spectre').setup({
      default = {
        replace = {
          cmd = "oxi"
        }
      }
    })
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>frt',
      '<cmd>lua require("spectre").toggle()<CR>',
      desc = 'Toggle Spectre'
    },
    {
      '<leader>fro',
      '<cmd>lua require("spectre").open()<CR>',
      desc = 'Search'
    },
    {
      '<leader>frw',
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      desc = 'Search current word'
    },
    {
      '<leader>frf',
      '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
      desc = 'Search on current file'
    }
  }
}
