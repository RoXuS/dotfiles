local eslint = {}
local notify = require('notify')
local utils = require('utils')

-- Default configuration
eslint.config = {
  folder = nil,         -- Default: root directory
  cache = false,        -- Default: no cache
  cache_location = nil, -- Default: ESLint's default cache location
}

-- Run ESLint with the configured options
local function run_eslint()
  local root_dir = utils.find_project_root({ '.git', 'package.json' })
  local target_dir = eslint.config.folder and (root_dir .. '/' .. eslint.config.folder) or root_dir
  local cache_flag = eslint.config.cache and '--cache' or ''
  local cache_location_flag = eslint.config.cache_location and ('--cache-location ' .. eslint.config.cache_location) or
      ''
  -- Print for debugging
  -- print('Running ESLint in directory:', target_dir)
  -- print('Cache flag:', cache_flag)
  -- print('Cache location flag:', cache_location_flag)
  -- print('Root dir', root_dir)
  local cmd = string.format('npx eslint --quiet --format json %s %s %s', target_dir, cache_flag, cache_location_flag)

  -- Persistent notification ID
  local notify_id = nil

  -- Notify the user that linting has started
  notify_id = notify('Running ESLint...', 'info', {
    title = 'ESLint',
    timeout = false, -- No timeout, notification stays open
    icon = '⏳', -- Spinner icon
    replace = notify_id, -- Replace the previous notification (if any)
  })

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      vim.schedule(function()
        -- Parse ESLint output
        local success, results = pcall(vim.fn.json_decode, table.concat(data, ''))
        if not success then
          notify('Failed to parse ESLint output.', 'error', {
            title = 'ESLint',
            replace = notify_id,
          })
          return
        end

        local qflist = {}
        for _, file in ipairs(results) do
          for _, message in ipairs(file.messages) do
            table.insert(qflist, {
              filename = file.filePath,
              lnum = message.line,
              col = message.column,
              text = message.message,
              type = message.severity == 2 and 'E' or 'W', -- 2 = error, 1 = warning
            })
          end
        end

        if #qflist > 0 then
          vim.fn.setqflist(qflist)
          vim.api.nvim_command('copen')
          notify(string.format('ESLint found %d issue(s).', #qflist), 'warn', {
            title = 'ESLint',
            icon = '⚠️', -- Warning icon
            replace = notify_id,
            timeout = 5000, -- Close the notification after 5 seconds
          })
        else
          vim.api.nvim_command('cclose')
          notify('No issues found.', 'info', {
            title = 'ESLint',
            icon = '✅', -- Success icon
            replace = notify_id,
            timeout = 5000, -- Close the notification after 5 seconds
          })
        end
      end)
    end,
    on_stderr = function(_, data)
      vim.schedule(function()
        local error_message = table.concat(data, '\n')
        if error_message ~= '' then
          notify(error_message, 'error', {
            title = 'ESLint Error',
            icon = '❌', -- Error icon
            replace = notify_id,
            timeout = 5000, -- Close the notification after 5 seconds
          })
        end
      end)
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code ~= 0 then
          notify('ESLint exited with an error.', 'error', {
            title = 'ESLint',
            icon = '❌', -- Error icon
            replace = notify_id,
            timeout = 5000, -- Close the notification after 5 seconds
          })
        end
      end)
    end,
  })
end

-- Setup function to configure the plugin
function eslint.setup(user_config)
  -- Merge user configuration with defaults
  eslint.config = vim.tbl_deep_extend('force', eslint.config, user_config or {})

  -- Create the user command
  vim.api.nvim_create_user_command('ESLintProject', run_eslint, {})
end

return eslint
