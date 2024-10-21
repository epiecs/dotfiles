local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder() then config = wezterm.config_builder() end

local bash_path = "/opt/homebrew/bin/bash"

-- WIN/Linux
local mod_key = "ALT"

-- Mac
local mod_key = "CMD"

-- Add folders to path
config.set_environment_variables = {
    PATH = '/usr/local/bin/:' .. os.getenv('PATH')
}

config = {
    automatically_reload_config = true,
    default_prog = { bash_path },
    adjust_window_size_when_changing_font_size = false,

    scrollback_lines = 10000,

    -- Window
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",

    window_background_opacity = 0.8,
    macos_window_background_blur = 30,

    window_padding = {
        left = 8,
        right = 8,
        top = 10,
        bottom = 5,
    },

    -- Colors
    color_scheme = 'Tokyo Night',
    
    -- Tab bar
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    status_update_interval = 1000,

    -- Panes
    inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.7,
    },

    -- Fonts
    font_size = 14,
    font = wezterm.font_with_fallback {
        {
            family = 'Cascadia Mono',
            weight = 'Bold',
        },
        {
            family = 'SF Mono',
            weight = 'DemiBold',
        },
        {
            family = 'Menlo',
            weight = 'Regular',
        },
        {
            family = 'JetBrains Mono',
            weight = 'Bold',
        },
    },

    -- Launch menu, commands and different shells
    launch_menu = {
        {
            label = "Powershell",
            args = {"/usr/local/bin/pwsh"},
        },
    },
    -- Debug
    -- debug_key_events = true
}

config.keys = {
    -- Send C-a when pressing C-a twice
    { key = "p",          mods = mod_key,               action = act.ShowLauncher },
    { key = "p",          mods = "SHIFT|"..mod_key,     action = act.ActivateCommandPalette },
  
    -- Pane keybindings
    { key = "=",          mods = "SHIFT|"..mod_key,     action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "-",          mods = "SHIFT|"..mod_key,     action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
   
    { key = "w",          mods = mod_key,               action = act.CloseCurrentPane { confirm = true } },
    { key = "Enter",      mods = mod_key,               action = act.TogglePaneZoomState },
    { key = "o",          mods = mod_key,               action = act.RotatePanes "Clockwise" },
    
    { key = "LeftArrow",  mods = mod_key,               action = act.ActivatePaneDirection("Left") },
    { key = "DownArrow",  mods = mod_key,               action = act.ActivatePaneDirection("Down") },
    { key = "UpArrow",    mods = mod_key,               action = act.ActivatePaneDirection("Up") },
    { key = "RightArrow", mods = mod_key,               action = act.ActivatePaneDirection("Right") },
    
    { key = "LeftArrow",  mods = "SHIFT|"..mod_key,     action = act.AdjustPaneSize{"Left", 5 } },
    { key = "DownArrow",  mods = "SHIFT|"..mod_key,     action = act.AdjustPaneSize{"Down", 5 } },
    { key = "UpArrow",    mods = "SHIFT|"..mod_key,     action = act.AdjustPaneSize{"Up", 5 } },
    { key = "RightArrow", mods = "SHIFT|"..mod_key,     action = act.AdjustPaneSize{"Right", 5 } },
    
    -- Tabs
    { key = "w",          mods = "SHIFT|"..mod_key,     action = act.CloseCurrentTab { confirm = true } },
    
    -- Fonts
    { key = "-",          mods = mod_key,               action = act.DecreaseFontSize },
    { key = "=",          mods = mod_key,               action = act.IncreaseFontSize },

    -- Resize panes
    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    { key = "r",          mods = mod_key,               action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
  
    -- Tab keybindings
    { key = "t",          mods = mod_key,               action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[",          mods = mod_key,               action = act.ActivateTabRelative(-1) },
    { key = "]",          mods = mod_key,               action = act.ActivateTabRelative(1) },
    { key = "t",          mods = "SHIFT|"..mod_key,     action = act.ShowTabNavigator },
    {
      key = "e",
      mods = "SHIFT|"..mod_key,
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        },
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end)
      }
    },
}

return config
