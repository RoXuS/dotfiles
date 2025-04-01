local wezterm = require "wezterm"
local open_in_nvim = require("open-in-nvim")
local projects = require 'projects'

wezterm.on('gui-startup', function()
  projects.open_first_project()
end)

-- Notification when the configuration is reloaded
wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'Configuration reloaded!', nil, 2000)
end)

-- This function is called by wezterm to assign a color scheme following Dark or Light appearance
local function scheme_for_appearance()
  local appearance = wezterm.gui.get_appearance()
  if appearance:find "Dark" then
    return "Catppuccin Frappe"
  else
    return "Catppuccin Latte"
  end
end

-- Call perriodically, I use it to update the status bar with the name of the current workspace
wezterm.on('update-status', function(window, _pane)
  window:set_right_status(wezterm.format {
    { Text = window:active_workspace() },
  })
end)

-- Get the right tab title
local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

-- Callback to format title of the tab
wezterm.on(
  'format-tab-title',
  function(tab)
    local title = tab_title(tab)
    return {
      { Text = ' ' .. title .. ' ' },
    }
  end
)

return {
  audible_bell = "Disabled",
  mouse_bindings = {
    -- Disable the default click behavior
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.DisableDefaultAssignment,
    },
    -- Bind 'Up' event of CTRL-Click to open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'SUPER',
      action = wezterm.action.Nop,
    },
  },
  color_scheme = scheme_for_appearance(),
  use_fancy_tab_bar = false,
  window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  },
  notification_handling = "NeverShow",
  show_tab_index_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  tab_bar_at_bottom = true,
  font = wezterm.font("Hack Nerd Font"),
  font_size = 14.0,
  leader = { key = "b", mods = "CTRL" },
  quick_select_patterns = {
    'IN-\\d+'
  },
  send_composed_key_when_left_alt_is_pressed = true,
  keys = {
    {
      key = 'r',
      mods = 'CMD|SHIFT',
      action = wezterm.action.ReloadConfiguration,
    },
    {
      key = "i",
      mods = "LEADER",
      action = wezterm.action.QuickSelectArgs({
        patterns = {
          [[[/.A-Za-z0-9_-]+\.[A-Za-z0-9]+[:\d+]*(?=\s*|$)]],
        },
        action = wezterm.action_callback(function(window, pane)
          local path = window:get_selection_text_for_pane(pane)
          open_in_nvim.open_in_nvim(window, pane, "$EDITOR:" .. path)
        end),
      })
    },
    -- TMUX BINDING
    -- Panes navigations
    { key = "\"", mods = "LEADER",       action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "%",  mods = "LEADER",       action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    { key = "z",  mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "c",  mods = "LEADER",       action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
    { key = "h",  mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Left" } },
    { key = "j",  mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Down" } },
    { key = "k",  mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Up" } },
    { key = "l",  mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Right" } },
    { key = "H",  mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 5 } } },
    { key = "J",  mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 5 } } },
    { key = "K",  mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 5 } } },
    { key = "L",  mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 5 } } },
    { key = "x",  mods = "LEADER",       action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    -- Tabs navigations
    { key = "1",  mods = "LEADER",       action = wezterm.action { ActivateTab = 0 } },
    { key = "2",  mods = "LEADER",       action = wezterm.action { ActivateTab = 1 } },
    { key = "3",  mods = "LEADER",       action = wezterm.action { ActivateTab = 2 } },
    { key = "4",  mods = "LEADER",       action = wezterm.action { ActivateTab = 3 } },
    { key = "5",  mods = "LEADER",       action = wezterm.action { ActivateTab = 4 } },
    { key = "6",  mods = "LEADER",       action = wezterm.action { ActivateTab = 5 } },
    { key = "7",  mods = "LEADER",       action = wezterm.action { ActivateTab = 6 } },
    { key = "8",  mods = "LEADER",       action = wezterm.action { ActivateTab = 7 } },
    { key = "9",  mods = "LEADER",       action = wezterm.action { ActivateTab = 8 } },
    { key = 'a',  mods = 'LEADER|CTRL',  action = wezterm.action.ActivateLastTab, },
    { key = 'o',  mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'p',  mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(1) },
    -- Rename tab
    {
      key = ',',
      mods = 'LEADER',
      action = wezterm.action.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for the current tab' },
        },
        action = wezterm.action_callback(function(window, _pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
    -- URL HANDLING WITH KEYBOARD AND QuickSelectArgs
    {
      key = 'u',
      mods = 'LEADER',
      action = wezterm.action.QuickSelectArgs {
        label = 'open url',
        patterns = {
          'https?://\\S+',
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.open_with(url)
        end),
      },
    },
    -- Show projects
    {
      key = 'p',
      mods = 'CTRL|SHIFT',
      action = projects.choose_project(),
    },
    -- Show wokspaces
    {
      key = 'l',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ShowLauncherArgs {
        flags = 'FUZZY|WORKSPACES',
      },
    },
    -- Rename workspace
    {
      key = 'r',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for new workspace' },
        },
        action = wezterm.action_callback(function(_window, _pane, line)
          if line then
            wezterm.mux.rename_workspace(
              wezterm.mux.get_active_workspace(),
              line
            )
          end
        end),
      },
    },
    -- Create new workspace with name
    {
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for new workspace' },
        },
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              wezterm.action.SwitchToWorkspace {
                name = line,
              },
              pane
            )
          end
        end),
      },
    },
  },
}
