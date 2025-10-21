-- Automatically switch between light and dark mode
return {
  "f-person/auto-dark-mode.nvim",
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option_value("background", "dark", {})
      vim.cmd("colorscheme catppuccin-frappe")
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value("background", "light", {})
      vim.cmd("colorscheme catppuccin-latte")
    end,
  },
  init = function()
    -- Si pas d'environnement graphique, utiliser le mode sombre par défaut
    if vim.fn.has("gui_running") == 0 and os.getenv("DISPLAY") == nil then
      vim.opt.background = "dark"
      vim.cmd("colorscheme catppuccin-frappe")
    end
  end,
}
