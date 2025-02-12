local stylelint = {}
local utils = require('utils') -- Import the utils module

-- Default configuration
stylelint.config = {
  folder = nil,         -- Default: root directory
  cache = false,        -- Default: no cache
  cache_location = nil, -- Default: Stylelint's default cache location
}

-- Run Stylelint with the configured options
local function run_stylelint()
  local root_dir = utils.find_project_root({ '.git', 'package.json' }) -- Use the utility function
  local target_dir = stylelint.config.folder and (root_dir .. '/' .. stylelint.config.folder) or root_dir
  local cache_flag = stylelint.config.cache and '--cache' or ''
  local cache_location_flag = stylelint.config.cache_location and
      ('--cache-location ' .. stylelint.config.cache_location) or ''
  local cmd = string.format('npx stylelint --formatter json %s %s %s', target_dir, cache_flag, cache_location_flag)

  -- Persistent notification ID
  local notify_id = nil

  -- Notify the user that linting has started
  notify_id = require('notify')('Running Stylelint...', 'info', {
    title = 'Stylelint',
    timeout = false, -- No timeout, notification stays open
    icon = '⏳', -- Spinner icon
    replace = notify_id, -- Replace the previous notification (if any)
  })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      vim.schedule(function()
        -- If stdout is empty, it means Stylelint ran successfully with no issues
        if not data or #data == 0 or data[1] == '' then
          -- Close the quickfix list if it's open
          if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
            vim.api.nvim_command('cclose')
          end

          -- Notify the user of success
          require('notify')('No issues found.', 'info', {
            title = 'Stylelint',
            icon = '✅', -- Success icon
            timeout = 5000, -- 5-second timeout
            replace = notify_id,
          })
        end
      end)
    end,
    on_stderr = function(_, data)
      vim.schedule(function()
        -- Check if data is empty or invalid
        if not data or #data == 0 or data[1] == '' then
          require('notify')('Stylelint produced no output.', 'warn', {
            title = 'Stylelint',
            timeout = 5000, -- 5-second timeout
            replace = notify_id,
          })
          return
        end

        -- Parse Stylelint output from stderr
        local success, results = pcall(vim.fn.json_decode, table.concat(data, ''))
        if not success then
          require('notify')('Failed to parse Stylelint output.', 'error', {
            title = 'Stylelint',
            timeout = 5000, -- 5-second timeout
            replace = notify_id,
          })
          return
        end

        local qflist = {}
        if type(results) == 'table' then
          for _, file in ipairs(results) do
            if file.warnings and type(file.warnings) == 'table' then
              for _, warning in ipairs(file.warnings) do
                table.insert(qflist, {
                  filename = file.source,
                  lnum = warning.line,
                  col = warning.column,
                  text = warning.text,
                  type = warning.severity == 'error' and 'E' or 'W', -- 'error' or 'warning'
                })
              end
            end
          end
        end

        if #qflist > 0 then
          vim.fn.setqflist(qflist)
          vim.api.nvim_command('copen')
          require('notify')(string.format('Stylelint found %d issue(s).', #qflist), 'warn', {
            title = 'Stylelint',
            icon = '⚠️', -- Warning icon
            timeout = 5000, -- 5-second timeout
            replace = notify_id,
          })
        else
          -- Close the quickfix list if it's open
          if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
            vim.api.nvim_command('cclose')
          end

          require('notify')('No issues found.', 'info', {
            title = 'Stylelint',
            icon = '✅', -- Success icon
            timeout = 5000, -- 5-second timeout
            replace = notify_id,
          })
        end
      end)
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code ~= 0 then
          require('notify')('Stylelint exited with an error.', 'error', {
            title = 'Stylelint',
            icon = '❌', -- Error icon
            timeout = 5000, -- 5-second timeout
            replace = notify_id,
          })
        end
      end)
    end,
  })
end

-- Setup function to configure the plugin
function stylelint.setup(user_config)
  -- Merge user configuration with defaults
  stylelint.config = vim.tbl_deep_extend('force', stylelint.config, user_config or {})

  -- Create the user command
  vim.api.nvim_create_user_command('StylelintProject', run_stylelint, {})
end

return stylelint
