return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')
    lspconfig.ts_ls.setup({
      root_dir = function(filename)
        if (lspconfig.util.root_pattern("package.json")(filename) or lspconfig.util.root_pattern("tsconfig.json")(filename)) then
          return lspconfig.util.find_git_ancestor(filename)
        end
      end,
      single_file_support = false,
      settings = {
        workingDirectory = { mode = 'location' },
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
      },
    })
    lspconfig.pyright.setup({})
    lspconfig.stylelint_lsp.setup({
      filetypes = { "typescript" },
      root_dir = lspconfig.util.root_pattern("package.json", ".git"),
      settings = {
        stylelintplus = {
          autoFixOnSave = true,
        },
      },
      on_attach = function(client)
        client.server_capabilities.document_formatting = false
      end,
    })
    lspconfig.denols.setup {
      root_dir = lspconfig.util.root_pattern("deno.json"),
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end
        })
        -- Disable eslint for deno project
        if lspconfig.util.root_pattern("package.json")(vim.fn.getcwd()) then
          if client.name == "denols" then
            client.stop()
            return
          end
        end
      end,
    }
    lspconfig.eslint.setup {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
        -- Disable eslint for deno project
        if lspconfig.util.root_pattern("deno.json")(vim.fn.getcwd()) then
          if client.name == "eslint" then
            client.stop()
            return
          end
        end
      end,
      settings = {
        workingDirectory = { mode = 'location' },
      },
      root_dir = function(filename)
        if (lspconfig.util.root_pattern("eslint.config.js")(filename)) then
          return lspconfig.util.root_pattern("eslint.config.js")(filename)
        elseif (lspconfig.util.root_pattern("eslint.config.mjs")(filename)) then
          return lspconfig.util.root_pattern("eslint.config.mjs")(filename)
        end

        -- if (lspconfig.util.root_pattern("package.json")(filename) or lspconfig.util.root_pattern("tsconfig.json")(filename)) then
        --   return lspconfig.util.find_git_ancestor(filename)
        -- end
      end
    }
    lspconfig.lua_ls.setup {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end
        })
      end,
      settings = {
        Lua = {
          runtime = {
            version = 'luajit',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
    -- lsp mapping keys
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local lspsaga = require('lspsaga')
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        nmap('gD', vim.lsp.buf.declaration, 'Declaration')
        nmap('gd', vim.lsp.buf.definition, 'Definition')
        nmap('<leader>o', vim.lsp.buf.format, 'Format')
        nmap('<leader>.', '<Cmd>Lspsaga code_action<CR>', 'Autofix')
        nmap('gvd', vim.lsp.buf.type_definition, 'Go to type definition')
        nmap('gi', vim.lsp.buf.implementation, 'Go to implementations')
        nmap('gh', vim.lsp.buf.hover, 'Signature help')
        nmap('gr', vim.lsp.buf.references, 'Go to references')
        -- nmap('<space>wa', vim.lsp.buf.add_workspace_folder, 'Add to workspace')
        -- nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, 'Remove from workspace')
        -- nmap('<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, 'List workspace folders')
      end,
    })
  end
}
