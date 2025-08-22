-- Manage git files, add gblame...
return {
  'lewis6991/gitsigns.nvim',
  config = true,
  event = 'VeryLazy',
  keys = {
    {
      '<leader>hn',
      function()
        local gitsigns = require('gitsigns')
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end,
      desc = 'Next hunk',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hp',
      function()
        local gitsigns = require('gitsigns')
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end,
      desc = 'Preview hunk',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hs',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.stage_hunk()
      end,
      desc = 'Stage hunk',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hr',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.reset_hunk()
      end,
      desc = 'Reset hunk',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hS',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.stage_buffer()
      end,
      desc = 'Stage buffer',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hu',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.undo_stage_hunk()
      end,
      desc = 'Undo stage hunk',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hR',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.reset_buffer()
      end,
      desc = 'Reset buffer',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hp',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.preview_hunk()
      end,
      desc = 'Preview hunk',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hb',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.blame_line { full = true }
      end,
      desc = 'Blame line',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hd',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.diffthis()
      end,
      desc = 'Diff this',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>hD',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.diffthis('~')
      end,
      desc = 'Diff this (reverse)',
      mode = { "n" },
      silent = true,
    },
    {
      '<leader>td',
      function()
        local gitsigns = require('gitsigns')
        gitsigns.toggle_deleted()
      end,
      desc = 'Toggle deleted',
      mode = { "n" },
      silent = true,
    },
    {
      'ih',
      function()
        require('gitsigns').select_hunk()
      end,
      desc = 'Select hunk',
      mode = { "o", "x" },
    }
  }
}
