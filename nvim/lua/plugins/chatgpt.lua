return {
  "olimorris/codecompanion.nvim",
  config = function()
    require("codecompanion").setup({
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("copilot", {
            env = {
              api_key = os.getenv("CHAT_GPT_API_KEY_CMD"),
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
    })
  end,
}
