-- My favorite color scheme
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      default_integrations = true,
      integrations = {
        copilot_vim = true,
        barbar = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
          dim_context = true,
          alt_background = true,
        },
        lsp_trouble = true,
        which_key = true,
        fidget = true,
        colorful_winsep = {
          enable = true,
          color = "red"
        },
        lsp_saga = true,
        telescope = {
          enabled = true,
          style = "nvchad"
        },
      }
    })
    require("barbecue").setup {
      theme = "catppuccin",
    }
  end
}
