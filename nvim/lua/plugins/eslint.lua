return {
  dir = "~/dotfiles/nvim/lua",
  dependencies = {
    "rcarriga/nvim-notify",
  },
  name = "eslint",
  config = function()
    require('eslint').setup({
      folder = 'packages',               -- Lint the `src` folder
      cache = true,                      -- Enable ESLint cache
      cache_location = './.eslintcache', -- Custom cache location
    })
  end,
}
