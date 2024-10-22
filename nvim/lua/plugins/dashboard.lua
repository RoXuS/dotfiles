-- A simple dashboard
return {
  'glepnir/dashboard-nvim',
  event = 'VimEnter',
  config = true,
  opts = {
    theme = 'doom',
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        {
          icon = ' ',
          icon_hl = '@variable',
          desc = 'Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
      },
    },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
}
