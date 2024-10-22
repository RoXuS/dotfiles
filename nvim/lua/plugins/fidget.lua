-- UI notification (bottomn right) for LSP diagnostics...
return {
  'j-hui/fidget.nvim',
  config = true,
  opts = {
    notification = {
      window = {
        winblend = 0,
      },
    }
  }
}
