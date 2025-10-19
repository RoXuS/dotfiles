return {
  'neovim/nvim-lspconfig',
  config = function()
    local util = require('lspconfig.util')

    ---------------------------------------------------------------------------
    -- 1) Déclarations des serveurs (pas d’activation ici)
    ---------------------------------------------------------------------------

    -- TypeScript / JavaScript
    vim.lsp.config('ts_ls', {
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
          },
        },
      },
    })

    -- Terraform
    vim.lsp.config('terraformls', {
    })
    vim.lsp.config('tflint', {
    })

    -- Pyright
    vim.lsp.config('pyright', {})

    -- GitHub Actions
    vim.lsp.config('gh_actions_ls', {})

    -- Stylelint
    vim.lsp.config('stylelint_lsp', {
      filetypes = { 'typescript' }, -- comme ta config d’origine
      settings = { stylelintplus = { autoFixOnSave = true } },
      on_attach = function(client)
        -- clé moderne (Neovim 0.10/0.11+)
        client.server_capabilities.documentFormattingProvider = false
      end,
    })

    -- Deno
    vim.lsp.config('denols', {
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function() vim.lsp.buf.format() end,
        })
      end,
    })

    -- ESLint
    vim.lsp.config('eslint', {
      settings = { workingDirectory = { mode = 'location' } },
      on_attach = function(_, bufnr)
        local function eslint_fix_all_sync()
          local position_encoding = vim.lsp.get_client_by_id(
            vim.lsp.get_clients({ bufnr = bufnr })[1].id
          ).offset_encoding or "utf-16"

          local params = vim.lsp.util.make_range_params(nil, position_encoding)
          params.context = {
            only = { "source.fixAll.eslint" },
            diagnostics = vim.diagnostic.get(bufnr),
          }

          -- 1) Demande synchrone des code actions
          local responses = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 2000)
          if not responses then return end

          -- 2) Cherche l’action "fixAll" et l’applique
          for _, resp in pairs(responses) do
            local actions = resp.result or {}
            for _, action in ipairs(actions) do
              local kind = action.kind or ''
              local title = action.title or ''
              if kind:find('source%.fixAll%.eslint') or title:lower():find('fix all') then
                -- Certaines actions renvoient directement des edits
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, 'utf-16')
                end
                -- D’autres nécessitent un executeCommand
                local command = action.command or action
                if command and command.command then
                  -- Synchrone ici aussi pour garantir l’application avant l’écriture
                  vim.lsp.buf_request_sync(bufnr, 'workspace/executeCommand', command, 2000)
                end
                return
              end
            end
          end
        end

        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = eslint_fix_all_sync,
        })
      end,
    })

    -- Lua
    vim.lsp.config('lua_ls', {
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function() vim.lsp.buf.format() end,
        })
      end,
      settings = {
        Lua = {
          runtime     = { version = 'luajit' },
          diagnostics = { globals = { 'vim' } },
          workspace   = { library = vim.api.nvim_get_runtime_file('', true) },
          telemetry   = { enable = false },
        },
      },
    })

    ---------------------------------------------------------------------------
    -- 2) Politique d’activation : décider QUAND activer, par buffer
    --    -> plus besoin de root_dir : on checke des marqueurs et on active
    ---------------------------------------------------------------------------

    local function has(marker_list, fname)
      return util.root_pattern(unpack(marker_list))(fname) ~= nil
    end

    local function is_deno(fname)
      return has({ 'deno.json', 'deno.jsonc' }, fname)
    end

    local function has_ts(fname)
      return has({ 'tsconfig.json', 'tsconfig.base.json', 'jsconfig.json', 'package.json' }, fname)
    end

    local function has_eslint(fname)
      return has({
        'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
        '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', '.eslintrc.yml', '.eslintrc.yaml',
        'package.json',
      }, fname)
    end

    -- JS/TS : activer Deno OU TS (+ ESLint si présent)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      callback = function(ev)
        local fname = vim.api.nvim_buf_get_name(ev.buf)

        if is_deno(fname) and not has_ts(fname) then
          -- Projet Deno "pur"
          vim.lsp.enable('denols', { bufnr = ev.buf })
          return
        end

        -- Projet TS/JS standard
        vim.lsp.enable('ts_ls', { bufnr = ev.buf })

        if has_eslint(fname) and not is_deno(fname) then
          vim.lsp.enable('eslint', { bufnr = ev.buf })
        end

        -- Stylelint : tu le voulais seulement sur TS
        vim.lsp.enable('stylelint_lsp', { bufnr = ev.buf })
      end,
    })

    -- Python
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'python' },
      callback = function(ev)
        vim.lsp.enable('pyright', { bufnr = ev.buf })
      end,
    })

    -- Terraform
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'terraform', 'tf' },
      callback = function(ev)
        local f = vim.api.nvim_buf_get_name(ev.buf)
        vim.lsp.enable('terraformls', { bufnr = ev.buf })
        vim.lsp.enable('tflint', { bufnr = ev.buf })
      end,
    })

    -- Lua
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lua' },
      callback = function(ev)
        vim.lsp.enable('lua_ls', { bufnr = ev.buf })
      end,
    })

    -- GitHub Actions (YAML dans .github/workflows)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'yaml', 'yml' },
      callback = function(ev)
        local f = vim.api.nvim_buf_get_name(ev.buf)
        if f:match('/%.github/workflows/') then
          vim.lsp.enable('gh_actions_ls', { bufnr = ev.buf })
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- 3) Tes mappings/omnifunc via LspAttach (inchangés)
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local lspsaga = require('lspsaga') -- si tu l'utilises
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        nmap('gD', vim.lsp.buf.declaration, 'Declaration')
        nmap('gd', vim.lsp.buf.definition, 'Definition')
        nmap('<leader>o', vim.lsp.buf.format, 'Format')
        nmap('<leader>.', '<Cmd>Lspsaga code_action<CR>', 'Autofix')
        nmap('gvd', vim.lsp.buf.type_definition, 'Go to type definition')
        nmap('gi', vim.lsp.buf.implementation, 'Go to implementations')
        nmap('gh', vim.lsp.buf.hover, 'Signature help')
        nmap('gr', vim.lsp.buf.references, 'Go to references')
      end,
    })
  end,
}
