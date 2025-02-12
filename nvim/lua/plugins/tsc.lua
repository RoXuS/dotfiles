-- Add tsc command
return {
  "dmmulroy/tsc.nvim",
  config = true,
  opts = {
    use_trouble_qflist = false,
    auto_open_qflist = true,
    auto_close_qflist = true,
    auto_start_watch_mode = true
  },
  dependencies = {
    "rcarriga/nvim-notify",
  },
}
