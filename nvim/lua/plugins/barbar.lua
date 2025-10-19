--- Added safe close wrapper to éviter boucle quand on spam la fermeture
---@diagnostic disable: undefined-global
return {
  'romgrk/barbar.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  version = '^1.0.0', -- only update when a new 1.x version is released
  config = function()
    -- Setup with defaults (only if not already auto-configured)
    local ok, barbar = pcall(require, 'barbar')
    if ok and barbar.setup then
      barbar.setup {}
    end

    -- Throttle pour éviter réouverture/fermeture en boucle si l'utilisateur garde <C-c> appuyé
    local last_close = 0
    local throttle_ns = 180 * 1e6 -- 180ms
    local closing = false

    local function safe_buffer_close()
      if closing then return end
      local now = vim.loop.hrtime()
      if (now - last_close) < throttle_ns then
        return
      end
      closing = true
      last_close = now
      -- pcall pour éviter erreurs qui pourraient relancer la commande
      pcall(vim.cmd, 'BufferClose')
      -- libérer le flag après un léger délai (éviter rebonds internes)
      vim.defer_fn(function() closing = false end, 50)
    end

    -- Remap après chargement du plugin pour override mapping initial défini avant lazy
    vim.keymap.set('n', '<C-c>', safe_buffer_close, { desc = 'Close buffer (safe)' })

    -- Mapping restore (corrige description précédente qui disait "Close buffer")
    vim.keymap.set('n', '<C-x>', '<Cmd>BufferRestore<CR>', { desc = 'Restore last closed buffer' })

    -- Debug option : mettre :let g:barbar_buffer_debug=1 pour voir évènements
    vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
      callback = function(args)
        if vim.g.barbar_buffer_debug == 1 then
          local name = vim.api.nvim_buf_get_name(args.buf)
          vim.notify(('Buffer deleted %d: %s'):format(args.buf, name ~= '' and name or '[No Name]'), vim.log.levels.DEBUG)
        end
      end,
    })
  end,
}
