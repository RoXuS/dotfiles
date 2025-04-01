-- Display and use snippets
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local plenary = require('plenary.scandir')
    local cwd = vim.fn.getcwd()
    local file = vim.fn.getcwd() .. "/.vscode/ts.code-snippets"

    local files = plenary.scan_dir(cwd .. "/.vscode", {
      depth = 2,
      hidden = true,
      search_pattern = ".code[-]snippets$" -- extension ".code-snippets"
    })

    if #files > 0 then
      for _, file in ipairs(files) do
        local text1 = file
        local substring1 = ".code-snippets"

        if string.find(text1, substring1, 0, true) == nil then
          vim.print('The string does not contain the substring.')
        else
          require("luasnip.loaders.from_vscode").load_standalone({ lazy = false, path = file })
        end
      end
    else
      vim.print('No .code-snippets files found in the CWD.')
    end
  end,
  keys = {
    {
      '<C-K>',
      function()
        local ls = require("luasnip")
        ls.expand()
      end,
      desc = 'Find files',
      mode = { "i" },
      silent = true,
    },
    {
      '<C-L>',
      function()
        local ls = require("luasnip")
        ls.jump(1)
      end,
      desc = 'Find files',
      mode = { "i", "s" },
      silent = true,
    },
    {
      '<C-J>',
      function()
        local ls = require("luasnip")
        ls.jump(-1)
      end,
      desc = 'Find files',
      mode = { "i", "s" },
      silent = true,
    },
    {
      '<C-E>',
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      desc = 'Find files',
      mode = { "i", "s" },
      silent = true,
    },
  }
}
