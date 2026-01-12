local wezterm = require 'wezterm'

return {
    scrollback_lines = 200000,

    color_scheme = "Dark Pastel",
    colors = {
        --     background = "#000000",
        --     foreground = "#ffffff",
        ansi = {
            "#000000", -- black
            "#ff5555", -- red
            "#50fa7b", -- green
            "#f1fa8c", -- yellow
            "#8be9fd", -- BLUE (34m) ← my fix
            "#ff79c6", -- magenta
            "#8be9fd", -- cyan
            "#bbbbbb", -- white
        },
        brights = {
            "#000000", -- black
            "#ff5555", -- red
            "#50fa7b", -- green
            "#f1fa8c", -- yellow
            "#8be9fd", -- BLUE (34m) ← my fix
            "#ff79c6", -- magenta
            "#8be9fd", -- cyan
            "#bbbbbb", -- white
        },
        visual_bell = "#101010"
        -- bold_brightens_ansi_colors = false,
    },
    font = wezterm.font('JetBrains Mono'),
    font_size = 16.0,
    window_background_opacity = 1.0,
    window_decorations = "RESIZE",

    audible_bell = "Disabled",
    visual_bell = {
        fade_in_function = 'Linear',
        fade_in_duration_ms = 150,
        fade_out_function = 'Linear',
        fade_out_duration_ms = 150,
    },

    leader = { key = 'Q', mods = 'OPT', timeout_milliseconds = 2000 },
    keys = {
        {
            key = "D",
            mods = "OPT|SHIFT",
            action = wezterm.action.SplitHorizontal({}),
        },
        {
            key = "A",
            mods = "OPT|SHIFT",
            action = wezterm.action.SplitVertical({}),
        },
        {
            key = "W",
            mods = "OPT|SHIFT",
            action = wezterm.action.CloseCurrentPane({ confirm = false }),
        },
        {
            key = "W",
            mods = "CTRL|SHIFT",
            action = wezterm.action.CloseCurrentPane({ confirm = false }),
        },
        {
            key = "Y",
            mods = "CTRL|SHIFT",
            action = wezterm.action_callback(function(win, pane)
                pane:move_to_new_tab()
            end)
        },
        {
            key = "M",
            mods = "CTRL|SHIFT",
            action = wezterm.action_callback(function(win, pane)
                pane:move_to_new_window()
            end)
        },
        {
            key = "h",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = "l",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = "j",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        {
            key = "k",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = "LeftArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = "RightArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = "DownArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        {
            key = "UpArrow",
            mods = "LEADER",
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = "H",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Left', 5 },
        },
        {
            key = "L",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Right', 5 },
        },
        {
            key = "J",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Down', 2 },
        },
        {
            key = "K",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Up', 2 },
        },
        {
            key = "LeftArrow",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Left', 5 },
        },
        {
            key = "RightArrow",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Right', 5 },
        },
        {
            key = "UpArrow",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Up', 2 },
        },
        {
            key = "DownArrow",
            mods = "OPT|SHIFT",
            action = wezterm.action.AdjustPaneSize { 'Down', 2 },
        },

    },

    mouse_bindings = {
        -- disable default click-to-open
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "NONE",
            action = wezterm.action.Nop,
        },

        -- require ctrl+click to open links
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },
}
