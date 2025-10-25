return {
  "ojroques/nvim-osc52",
  event = "VeryLazy",
  config = function()
    local osc52 = require("osc52")

    osc52.setup({
      max_length = 0,   -- 0 = pas de limite
      silent = true,    -- pas de message "copied X bytes"
      trim = false,
    })

    -- Fonctions utilitaires
    local function copy()
      if vim.v.event.operator == "y" and vim.v.event.regname == "" then
        osc52.copy_register('"')
      end
    end

    -- Yank normal / visuel → copie OSC52 automatique
    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = copy,
    })
  end,
}

