-- Description : Use real vim tabs and scope them
return {
  "tiagovla/scope.nvim",
  config = function()
    require("scope").setup {
      hooks = {
        pre_tab_leave = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
          -- [other statements]
        end,

        post_tab_enter = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
          -- [other statements]
        end,
      }
    }
  end,
}
