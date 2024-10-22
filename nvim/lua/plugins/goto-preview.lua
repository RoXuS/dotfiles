-- Display lsp preview
return {
  'rmagatti/goto-preview',
  config = true,
  event = "BufEnter",
  opts = {
    default_mappings = true
  }
}
