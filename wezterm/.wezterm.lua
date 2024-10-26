local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder() then config = wezterm.config_builder() end

local is_mac <const> = wezterm.target_triple:find("darwin") ~= nil

-- WIN/Linux
local mod_ctrl = "CTRL"
local mod_alt  = "ALT"

-- Mac
if is_mac then
    mod_ctrl = "CMD"
    mod_alt  = "OPT"
end

-- Add folders to path
config.set_environment_variables = {
    PATH = '/usr/local/bin/:/opt/homebrew/bin/:' .. os.getenv('PATH')
}

config = {
    automatically_reload_config = true,
    adjust_window_size_when_changing_font_size = false,

    scrollback_lines = 10000,

    -- Window
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",

    window_background_opacity = 0.9,
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
    -- Use the `Fontbook` app on mac to get the correct font name
    -- Use `wezterm ls-fonts` to get a list of built-in fonts
    font_size = 14,
    font = wezterm.font_with_fallback {
        {
            family = '0xProto Nerd Font Mono',
            weight = 'Bold',
        },
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
    -- Commands and tab launcher
    { key = "p",          mods = mod_ctrl,               action = act.ShowLauncher },
    { key = "p",          mods = "SHIFT|"..mod_ctrl,     action = act.ActivateCommandPalette },

    -- Text navigation
    -- Make Option/alt-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = 'LeftArrow',  mods = mod_alt,                 action = act.SendString '\x1bb' },
    -- Make Option/alt-Right equivalent to Alt-f; forward-word
    { key = 'RightArrow', mods = mod_alt,                 action = act.SendString '\x1bf' },

    -- Pane keybindings
    { key = "-",          mods = "SHIFT|"..mod_ctrl,     action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "=",          mods = "SHIFT|"..mod_ctrl,     action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },

    { key = "w",          mods = mod_ctrl,               action = act.CloseCurrentPane { confirm = true } },
    { key = "Enter",      mods = "SHIFT|"..mod_ctrl,     action = act.TogglePaneZoomState },
    
    { key = "LeftArrow",  mods = mod_ctrl,               action = act.ActivatePaneDirection("Left") },
    { key = "DownArrow",  mods = mod_ctrl,               action = act.ActivatePaneDirection("Down") },
    { key = "UpArrow",    mods = mod_ctrl,               action = act.ActivatePaneDirection("Up") },
    { key = "RightArrow", mods = mod_ctrl,               action = act.ActivatePaneDirection("Right") },

    { key = "LeftArrow",  mods = "SHIFT|"..mod_ctrl,     action = act.AdjustPaneSize{"Left", 3 } },
    { key = "DownArrow",  mods = "SHIFT|"..mod_ctrl,     action = act.AdjustPaneSize{"Down", 3 } },
    { key = "UpArrow",    mods = "SHIFT|"..mod_ctrl,     action = act.AdjustPaneSize{"Up", 3 } },
    { key = "RightArrow", mods = "SHIFT|"..mod_ctrl,     action = act.AdjustPaneSize{"Right", 3 } },

    -- Tabs
    { key = "w",          mods = "SHIFT|"..mod_ctrl,     action = act.CloseCurrentTab { confirm = true } },

    -- Fonts
    { key = "-",          mods = mod_ctrl,               action = act.DecreaseFontSize },
    { key = "=",          mods = mod_ctrl,               action = act.IncreaseFontSize },

    -- Resize panes
    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    { key = "r",          mods = mod_ctrl,               action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

    -- Tab keybindings
    { key = "t",          mods = mod_ctrl,               action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[",          mods = mod_ctrl,               action = act.ActivateTabRelative(-1) },
    { key = "]",          mods = mod_ctrl,               action = act.ActivateTabRelative(1) },
    { key = "t",          mods = "SHIFT|"..mod_ctrl,     action = act.ShowTabNavigator },
    {
      key = "e",
      mods = "SHIFT|"..mod_ctrl,
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
