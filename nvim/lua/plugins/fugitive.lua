-- Give access to :Git + GBrowse...
return {
  'tpope/vim-fugitive',
  dependencies = {
    'shumphrey/fugitive-gitlab.vim'
  },
  config = function()
    local gitlab_hostname = os.getenv("GITLAB_HOSTNAME")
    if gitlab_hostname then
      vim.g.fugitive_gitlab_domains = {
        [gitlab_hostname] = 'https://' .. gitlab_hostname,
      }
    end
  end,
}
