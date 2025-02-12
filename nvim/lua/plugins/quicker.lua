return {
  'stevearc/quicker.nvim',
  event = "FileType qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  config = function()
    require('quicker').setup({
      use_default_opts = true,
      highlight = {
        -- Use treesitter highlighting
        treesitter = true,
        -- Use LSP semantic token highlighting
        lsp = true,
        -- Load the referenced buffers to apply more accurate highlights (may be slow)
        load_buffers = false,
      },
    })
  end
}
