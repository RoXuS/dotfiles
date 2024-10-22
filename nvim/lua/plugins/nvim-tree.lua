-- Menu
return {
  'nvim-tree/nvim-tree.lua',
  config = true,
  keys = {
    {
      '<leader>n',
      function()
        require("nvim-tree.api").tree.toggle()
      end,
      desc = 'Open tree'
    },
    {
      '<leader>m',
      function()
        require("nvim-tree.api").tree.open({ find_file = true })
      end,
      desc = 'Find file in Tree'
    },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}
