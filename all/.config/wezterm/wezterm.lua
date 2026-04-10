local wezterm = require 'wezterm'
local act = wezterm.action

-- wezterm.on('update-right-status', function(window, pane)
--     local date = wezterm.strftime '%Y-%m-%d %H:%M'
--
--     -- make it italic and underlined
--     window:set_right_status(wezterm.format {
--         { Attribute = { Underline = 'Single' } },
--         { Attribute = { Italic = true } },
--         { Text = date .. '   ' },
--     })
-- end)
-- default_cursor_style = "SteadyBlock"
-- enable_focus_reporting = false
-- use_ime = false
-- enable_kitty_keyboard = false


wezterm.on('update-right-status', function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}
    -- Figure out the cwd and host of the current pane.
    -- This will pick up the hostname for the remote host if your
    -- shell is using OSC 7 on the remote host.
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
        local cwd = ''
        -- local hostname = ''
        if type(cwd_uri) == 'userdata' then
            -- Running on a newer version of wezterm and we have
            -- a URL object here, making this simple!
            cwd = cwd_uri.file_path
            -- hostname = cwd_uri.host or wezterm.hostname()
        else
            -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
            -- which doesn't have the Url object
            cwd_uri = cwd_uri:sub(8)
            local slash = cwd_uri:find '/'
            if slash then
                -- hostname = cwd_uri:sub(1, slash - 1)
                -- and extract the cwd from the uri, decoding %-encoding
                cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
                    return string.char(tonumber(hex, 16))
                end)
            end
        end
        -- -- Remove the domain name portion of the hostname
        -- local dot = hostname:find '[.]'
        -- if dot then
        --   hostname = hostname:sub(1, dot - 1)
        -- end
        -- if hostname == '' then
        --   hostname = wezterm.hostname()
        -- end
        --
        table.insert(cells, cwd)
        -- table.insert(cells, hostname)
    end
    -- I like my date/time in this style: "Wed Mar 3 08:14"
    local date = wezterm.strftime '%a %b %-d %H:%M'
    table.insert(cells, date)
    -- An entry for each battery (typically 0 or 1 battery)
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
    end
    -- The powerline < symbol
    local LEFT_ARROW = utf8.char(0xe0b3)
    -- The filled in variant of the < symbol
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    -- Color palette for the backgrounds of each cell
    local colors = {
        '#3c1361',
        '#52307c',
        '#663a82',
        '#7c5295',
        '#b491c8',
    }

    -- Foreground color for the text across the fade
    local text_fg = '#c0c0c0'
    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0
    -- Translate a cell into elements
    function push(text, is_last)
        local cell_no = num_cells + 1
        table.insert(elements, { Foreground = { Color = text_fg } })
        table.insert(elements, { Background = { Color = colors[cell_no] } })
        table.insert(elements, { Text = ' ' .. text .. ' ' })
        if not is_last then
            table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
            table.insert(elements, { Text = SOLID_LEFT_ARROW })
        end
        num_cells = num_cells + 1
    end

    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == 0)
    end
    window:set_right_status(wezterm.format(elements))
end)
-- Status line attempt for Zsh Vi mode
-- wezterm.on("update-status", function(window, pane)
--   local mode = pane:get_user_vars().ZLE_MODE or ""
--   window:set_right_status(mode)
-- end)
local scheme = wezterm.color.get_builtin_schemes()['Dark Pastel'] -- pick any
scheme.ansi[5] = '#8be9fc'
scheme.brights[5] = '#8be9fc'
-- scheme.visual_bell = '#ff550f'


return {
    scrollback_lines = 200000,
    color_schemes = {
        ['dark-pastel-blue-fixed'] = scheme,
    },
    color_scheme = 'dark-pastel-blue-fixed',
    -- color_scheme = "Dark Pastel",
    -- colors = {
    --     --     background = "#000000",
    --     --     foreground = "#ffffff",
    --     ansi = {
    --         "#000000", -- black
    --         "#ff5555", -- red
    --         "#50fa7b", -- green
    --         "#f1fa8c", -- yellow
    --         "#8be9fd", -- BLUE (34m) ← my fix
    --         "#ff79c6", -- magenta
    --         "#8be9fd", -- cyan
    --         "#bbbbbb", -- white
    --     },
    --     brights = {
    --         "#000000", -- black
    --         "#ff5555", -- red
    --         "#50fa7b", -- green
    --         "#f1fa8c", -- yellow
    --         "#8be9fd", -- BLUE (34m) ← my fix
    --         "#ff79c6", -- magenta
    --         "#8be9fd", -- cyan
    --         "#bbbbbb", -- white
    --     },
    --     -- visual_bell = "#101010"
    --     -- bold_brightens_ansi_colors = false,
    -- },
    -- font = wezterm.font('JetBrains Mono'),
    -- font_size = 16.0,
    -- window_background_opacity = 1.0,
    -- window_decorations = "RESIZE",
    -- debug_key_events = true,
    -- window_close_confirmation = 'NeverPrompt',
    audible_bell = "Disabled",
    visual_bell = {
        fade_in_function = 'Linear',
        fade_in_duration_ms = 50,
        fade_out_function = 'Linear',
        fade_out_duration_ms = 50,
        target = "CursorColor",
    },
    -- color = "#ff550f",
    hyperlink_rules = {
        -- url matcher without trailing punctuation
        {
            regex = [[https?://[^\s\)\]\}>'"]+]],
            format = "$0",
        },
    },
    harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' },
    ssh_domains = {
        {
            name = "fedora",
            remote_address = "fedora",
        }
    },
    ssh_backend = "Ssh2",
    -- disable_default_key_bindings = true, -- one day
    leader = {
        key = 'Tab',
        mods = 'NONE',
        -- mods = 'SUPER',
        timeout_milliseconds = 750
    },
    keys = {
        { -- attempting to emit tab after double tap tab in insert mode (and wherever) 01/17/2026
            key = "Tab",
            mods = "LEADER",
            action = act.SendKey { key = 'Tab', mods = 'NONE' },
        },
        {
            key = 'Space',
            mods = 'LEADER',
            action = act.SendKey { key = 'Tab', mods = 'NONE' },
        },
        {
            key = "A",
            mods = "OPT|SHIFT",
            action = act.SplitHorizontal({}),
        },
        {
            key = "E",
            mods = "OPT|SHIFT",
            action = wezterm.action.SplitHorizontal({}),
        },
        {
            key = "D",
            mods = "OPT|SHIFT",
            action = wezterm.action.SplitVertical({}),
        },
        {
            key = "e",
            mods = "SUPER",
            action = wezterm.action.SplitPane({ direction = 'Right' }),
        },
        {
            key = "d",
            mods = "SUPER",
            action = wezterm.action.SplitPane({ direction = 'Down' }),
        },
        {
            key = "g",
            mods = "SUPER",
            action = wezterm.action.SplitPane({ direction = 'Left' }),
        },
        {
            key = "u",
            mods = "SUPER",
            action = wezterm.action.SplitPane({ direction = 'Up' }),
        },
        {
            key = "p",
            mods = "SUPER",
            action = wezterm.action.SpawnCommandInNewTab({ args = { 'btop' } }),
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
            key = "T",
            mods = "OPT|SHIFT",
            action = wezterm.action.SpawnTab 'CurrentPaneDomain',
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
        -- {
        --     key = "m",
        --     mods = "LEADER",
        --     action = wezterm.action_callback(function(win, pane)
        --         pane:move_to_new_window()
        --     end)
        -- },
        {
            key = "m",
            mods = "SUPER",
            action = wezterm.action_callback(function(win, pane)
                pane:move_to_new_window()
            end)
        },
        -- {
        --     key = "y",
        --     mods = "LEADER",
        --     action = wezterm.action_callback(function(win, pane)
        --         pane:move_to_new_tab()
        --     end)
        -- },
        {
            key = "y",
            mods = "SUPER",
            action = wezterm.action_callback(function(win, pane)
                pane:move_to_new_tab()
            end)
        },
        -- {
        --     key = "h",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Left',
        -- },
        -- {
        --     key = "l",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Right',
        -- },
        -- {
        --     key = "j",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Down',
        -- },
        -- {
        --     key = "k",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Up',
        -- },
        {
            key = "h",
            mods = "SUPER",
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = "l",
            mods = "SUPER",
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = "j",
            mods = "SUPER",
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        {
            key = "k",
            mods = "SUPER",
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        -- {
        --     key = "LeftArrow",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Left',
        -- },
        -- {
        --     key = "RightArrow",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Right',
        -- },
        -- {
        --     key = "DownArrow",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Down',
        -- },
        -- {
        --     key = "UpArrow",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivatePaneDirection 'Up',
        -- },
        -- {
        --     key = "p",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateTabRelative(-1),
        -- },
        -- {
        --     key = "n",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateTabRelative(1),
        -- },
        -- {
        --     key = "p",
        --     mods = "SUPER",
        --     action = wezterm.action.ActivateTabRelative(-1),
        -- },
        -- {
        --     key = "n",
        --     mods = "SUPER",
        --     action = wezterm.action.ActivateTabRelative(1),
        -- },
        -- {
        --     key = ",",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateTabRelative(-1),
        -- },
        -- {
        --     key = ".",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateTabRelative(1),
        -- },
        {
            key = ",",
            mods = "SUPER",
            action = wezterm.action.ActivateTabRelative(-1),
        },
        {
            key = ".",
            mods = "SUPER",
            action = wezterm.action.ActivateTabRelative(1),
        },
        -- {
        --     key = "[",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateTabRelative(-1),
        -- },
        -- {
        --     key = "]",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateTabRelative(1),
        -- },
        -- {
        --     key = "[",
        --     mods = "SUPER",
        --     action = wezterm.action.ActivateTabRelative(-1),
        -- },
        -- {
        --     key = "]",
        --     mods = "SUPER",
        --     action = wezterm.action.ActivateTabRelative(1),
        -- },
        -- {
        --     key = "w",
        --     mods = "LEADER",
        --     action = wezterm.action.CloseCurrentPane({ confirm = false }),
        -- },
        {
            key = "w",
            mods = "SUPER",
            action = wezterm.action.CloseCurrentPane({ confirm = false }),
        },
        -- {
        --     key = "t",
        --     mods = "LEADER",
        --     action = wezterm.action.SpawnTab 'CurrentPaneDomain',
        -- },
        -- {
        --     key = ":",
        --     mods = "LEADER",
        --     action = wezterm.action.ActivateCopyMode,
        -- },
        {
            key = ";",
            mods = "SUPER",
            action = wezterm.action.ActivateCopyMode,
        },
        -- {
        --     key = "h",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Left',
        -- },
        -- {
        --     key = "l",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Right',
        -- },
        -- {
        --     key = "j",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Down',
        -- },
        -- {
        --     key = "k",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Up',
        -- },
        -- {
        --     key = "LeftArrow",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Left',
        -- },
        -- {
        --     key = "RightArrow",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Right',
        -- },
        -- {
        --     key = "DownArrow",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Down',
        -- },
        -- {
        --     key = "UpArrow",
        --     mods = "LEADER|CTRL",
        --     action = wezterm.action.ActivatePaneDirection 'Up',
        -- },
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
        table.unpack((function()
            local k = {}
            for i = 1, 9 do
                k[#k + 1] = {
                    key = tostring(i),
                    mods = 'LEADER',
                    action = act.ActivateTab(i - 1),
                }
            end
            return k
        end)()),
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
    }
}
