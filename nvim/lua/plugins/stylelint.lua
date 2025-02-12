return {
  dir = "~/dotfiles/nvim/lua/stylelint",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  name = "stylelint/stylelint",
  config = function()
    require('stylelint/stylelint').setup({
      folder = 'packages/**/*/*.{ts,css}',  -- Lint the `src` folder
      cache = true,                         -- Enable ESLint cache
      cache_location = './.stylelintcache', -- Custom cache location
    })
  end,
}
