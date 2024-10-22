-- Highlighting and language parsing using treesitter
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local parser_install_dir = vim.fn.expand '~/.local/share/treesitter';
    vim.opt.runtimepath:append(parser_install_dir)
    require 'nvim-treesitter.configs'.setup {
      parser_install_dir = parser_install_dir,
      highlight = {
        enable = true,
        custom_captures = {
          ["(method_signature name:(property_identifier)"] = "BP_TSMethodSignature",
        },
        max_file_lines = 10000,
        disable = function(lang, bufnr)
          return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1048576
        end,
      },
      ensure_installed = {
        'html',
        'dockerfile',
        'json',
        'lua',
        'css',
        'markdown',
        'markdown_inline',
        'regex',
        'typescript',
        'yaml',
      },
      incremental_selection = {
        enable = false,
      },
      indent = {
        enable = false,
      },
      endwise = {
        enable = true,
      },
      textobjects = { enable = true },
      rainbow = {
        max_file_lines = 5000,
      }
    }
  end
}
