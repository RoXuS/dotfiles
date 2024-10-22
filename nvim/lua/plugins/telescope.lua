-- All telescope thing
return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-telescope/telescope-live-grep-args.nvim",
    "jonarrien/telescope-cmdline.nvim",
    "debugloop/telescope-undo.nvim",
    "natecraddock/telescope-zf-native.nvim",
    "benfowler/telescope-luasnip.nvim",
    "tpope/vim-rhubarb",
    "tpope/vim-fugitive",
    "aaronhallaert/advanced-git-search.nvim",
    "fdschmidt93/telescope-egrepify.nvim",
    "dhruvmanila/browser-bookmarks.nvim",
    { 'kkharji/sqlite.lua', module = 'sqlite' },
    "AckslD/nvim-neoclip.lua",
  },
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup {
      defaults = {
        prompt_prefix = "🔎 ",
        dynamic_preview_title = true,
        winblend = 10,
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "bottom",
          height = 0.95,
        },
        cache_picker = {
          num_pickers = -1,
        },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--ignore',
          '--hidden',
          '--trim',
        },
        file_ignore_patterns = {
          '.git/',
          'node_modules'
        },
        mappings = {
          i = {
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        undo = {},
        cmdline = {},
        ["zf-native"] = {
          -- options for sorting file-like items
          file = {
            -- override default telescope file sorter
            enable = true,

            -- highlight matching text in results
            highlight_results = true,

            -- enable zf filename match priority
            match_filename = true,

            -- optional function to define a sort order when the query is empty
            initial_sort = nil,

            -- set to false to enable case sensitive matching
            smart_case = true,
          },

          -- options for sorting all other items
          generic = {
            -- override default telescope generic item sorter
            enable = true,

            -- highlight matching text in results
            highlight_results = true,

            -- disable zf filename match priority
            match_filename = false,

            -- optional function to define a sort order when the query is empty
            initial_sort = nil,

            smart_case = true,
          },
        }
      }
    }
    require('neoclip').setup()
    require('browser_bookmarks').setup {
      selected_browser = 'chrome'
    }
    require('telescope').load_extension('luasnip')
    require("telescope").load_extension("advanced_git_search")
    require("telescope").load_extension('cmdline')
    require("telescope").load_extension("undo")
    require('telescope').load_extension('bookmarks')
    require("telescope").load_extension("zf-native")
  end,
  keys = {
    { ':', '<cmd>Telescope cmdline<cr>', desc = 'Cmdline' },
    {
      '<leader>ff',
      function()
        require("telescope.builtin").find_files()
      end,
      desc = 'Find files'
    },
    -- {
    --   '<leader>fg',
    --   function()
    --     require("telescope").extensions.live_grep_args.live_grep_args()
    --   end,
    --   desc = 'Find help tags'
    -- },
    {
      '<leader>fb',
      function()
        require("telescope.builtin").buffers()
      end,
      desc = 'Find buffers'
    },
    {
      '<leader>fh',
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = 'Find help tags'
    },
    {
      '<leader>fs',
      function()
        require("telescope").extensions.egrepify.egrepify()
      end,
      desc = 'Find in files'
    },
    {
      '<leader>fe',
      function()
        require("telescope").extensions.luasnip.luasnip()
      end,
      desc = 'Find snippets'
    },
    {
      '<leader>fg',
      function()
        vim.cmd("AdvancedGitSearch")
      end,
      desc = 'Git search'
    },
    {
      '<leader>fp',
      function()
        require("telescope").extensions.neoclip.default()
      end,
      desc = 'See yank history'
    },
    {
      "<leader>fu",
      "<cmd>Telescope undo<cr>",
      desc = "Undo history",
    },
    {
      "<leader>fc",
      function()
        require('telescope').extensions.bookmarks.bookmarks()
      end,
      desc = "Bookmarks",
    },
  }
}
