return {
  "olimorris/codecompanion.nvim",
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapters = { "copilot" },
        },
        inline = {
          adapters = { "copilot" },
        },
      },
    })
  end,
}
