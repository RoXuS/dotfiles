local wezterm = require 'wezterm'
local module = {}
local projectsList = require 'projects-list'

function module.open_first_project()
  local project = projectsList[1]

  local tab, build_pane, window = wezterm.mux.spawn_window {
    workspace = project.name,
    cwd = project.path,
  }

  wezterm.mux.set_active_workspace(project.name)
end

function module.choose_project()
  local choices = {}
  for i, value in ipairs(projectsList) do
    table.insert(choices, { label = value.name, id = tostring(i) })
  end

  return wezterm.action.InputSelector {
    title = 'Projects',
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if not label or not id then return end

      local project = projectsList[tonumber(id)]

      child_window:perform_action(wezterm.action.SwitchToWorkspace {
        name = label:match("([^/]+)$"),
        spawn = { cwd = project.path },
      }, child_pane)
    end),
  }
end

return module
