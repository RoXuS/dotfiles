-- Give access to :Git + GBrowse...
return {
  'tpope/vim-fugitive',
  dependencies = {
    'shumphrey/fugitive-gitlab.vim'
  },
  config = function()
    vim.g.fugitive_gitlab_domains = {
      [os.getenv("GITLAB_HOSTNAME")] = 'https://' .. os.getenv("GITLAB_HOSTNAME"),
    }
  end,
}
