local M = {}
local utils = require('utils') -- Import the utils module

function M.run_wdio()
  local current_file = vim.fn.expand('%:p') -- Get the full path of the current file

  -- Check if the file is a TypeScript file
  if not current_file:match('%.ts$') then
    vim.notify("This is not a TypeScript file.", vim.log.levels.ERROR)
    return
  end

  -- Get the root of the project (assuming it has a package.json)
  local root_dir = utils.find_project_root({ '.git', 'package.json' }) -- Use the utility function
  if root_dir == "" then
    vim.notify("Could not find project root (package.json).", vim.log.levels.ERROR)
    return
  end
  root_dir = vim.fn.fnamemodify(root_dir, ":p:h") -- Get the full path of the root directory

  -- Calculate the relative path of the current file from the project root
  local relative_path = vim.fn.fnamemodify(current_file, ":.") -- Get the relative path

  -- Generate a unique buffer name using a timestamp
  local buffer_name = "WDIO Output - " .. os.date("%Y-%m-%d %H:%M:%S")

  -- Create a new buffer to store the output
  local output_buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  vim.api.nvim_buf_set_name(output_buf, buffer_name)      -- Set a unique name for the buffer

  -- Create a horizontal split below the current buffer
  vim.api.nvim_command("belowright split") -- Open a split below the current window
  vim.api.nvim_win_set_buf(0, output_buf)  -- Set the new buffer in the split window
  vim.api.nvim_command("resize 14")        -- Set the height of the split window (adjust as needed)

  -- Initialize baleia.nvim for ANSI color support
  local baleia = require("baleia").setup({})

  -- Function to append a line to the buffer
  local function append_line(line)
    vim.schedule(function()
      local line_count = vim.api.nvim_buf_line_count(output_buf)
      -- Append the line to the buffer
      vim.api.nvim_buf_set_lines(output_buf, line_count, line_count, true, { line })

      -- Apply ANSI colors to the entire buffer
      baleia.once(output_buf)
    end)
  end

  -- Run the WDIO command and capture the output
  local Job = require("plenary.job") -- Use plenary.nvim for async job execution
  Job:new({
    command = "npx",
    args = { "wdio", "--spec", relative_path },
    cwd = root_dir, -- Run from the project root
    on_exit = function(job, exit_code)
      if exit_code == 0 then
        append_line("WDIO tests passed! 🎉")
      else
        append_line("WDIO tests failed! 😞")
      end
    end,
    on_stdout = function(_, data)
      append_line(data) -- Append output lines in real-time
    end,
    on_stderr = function(_, data)
      append_line(data) -- Append error lines in real-time
    end,
  }):start()
end

-- Create a command to run the WDIO test
vim.api.nvim_create_user_command('RunWdio', function()
  M.run_wdio()
end, {})

-- Map a keybinding (e.g., <leader>wr) to run the WDIO test
vim.keymap.set('n', '<leader>tr', '<cmd>RunWdio<CR>', { desc = 'Run WDIO on current file' })

return M
