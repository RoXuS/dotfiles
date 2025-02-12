return {
  name = "wdio-runner/wdio-runner",        -- Name of the plugin (can be anything)
  dir = "~/dotfiles/nvim/lua/wdio-runner", -- Path to the plugin directory
  config = function()
    require("wdio-runner/wdio-runner")     -- Load the plugin
  end,
  dependencies = {
    "rcarriga/nvim-notify",       -- Ensure nvim-notify is installed
    "m00qek/baleia.nvim",         -- For ANSI color support
    "nvim-lua/plenary.nvim",      -- For async job execution
  },
}
