local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Color scheme
config.color_scheme = 'Kanagawa'

-- Font configuration
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 15.0

-- Window configuration
config.window_background_opacity = 0.75
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
end)

-- Tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Key bindings
config.keys = {
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab{confirm=true},
  },
  { key = "w", mods = "ALT", action = wezterm.action.HideApplication },
}

-- Hotkey configuration
config.leader = { key = 'Space', mods = 'OPT', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = 'Space',
    mods = 'LEADER|OPT',
    action = wezterm.action.ToggleFullScreen,
  },
}

-- Set initial position and size (adjust as needed)
config.initial_rows = 40
config.initial_cols = 120

return config

