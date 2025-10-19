local addFlags = function(instanceName, flags)
  local grug = require('grug-far')
  if not grug.has_instance(instanceName) then
    grug.open({
      instanceName = instanceName,
      staticTitle = 'Find and Replace',
      prefills = { flags = flags }
    })
  else
    grug.get_instance(instanceName):open({
      staticTitle = 'Find and Replace',
      prefills = { flags = flags }
    })
  end
end

local addToggleFlagsCurrentInstance = function(pattern, flags, buf)
  vim.keymap.set('n', '<localleader>' .. pattern, function()
    local on = select(1, require('grug-far').get_instance(0):toggle_flags({ flags }))
    vim.notify('grug-far: ' .. flags .. ' ' .. (on and 'ON' or 'OFF'))
  end, { buffer = buf, desc = flags })
end

return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup({
    });
  end,
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'grug-far',
      callback = function(args)
        addToggleFlagsCurrentInstance('m', '--multiline', args.buf)
        addToggleFlagsCurrentInstance('d', '--pcre2', args.buf)
      end,
    })
  end,
  keys = {
    {
      '<leader>gg',
      '<cmd>lua require("grug-far").toggle_instance({ instanceName="far", staticTitle="Find and Replace" })<CR>',
      desc = 'Toggle GrugFar'
    },
    {
      '<leader>gp',
      function()
        addFlags('far-pcre2', '--pcre2')
      end,
      desc = 'Toggle GrugFar PCRE2',
    },
    {
      '<leader>gm',
      function()
        addFlags('far-multiline', '--multiline')
      end,
      desc = 'Toggle GrugFar Multiline',
    },
  }
}
