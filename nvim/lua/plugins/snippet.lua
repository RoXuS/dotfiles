-- Display and use snippets
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()
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
