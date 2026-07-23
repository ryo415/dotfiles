local M = {}
local wezterm = require "wezterm"
local act = wezterm.action

function M.apply_to(config)
    config.enable_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = true
    config.enable_wayland = true
    config.use_ime = true

    config.window_background_opacity = 0.95
    config.window_decorations = "NONE"

    config.front_end = "WebGpu"
    -- config.front_end = "OpenGL"
    -- config.front_end = "Software"

    config.window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
    }

    -- only copy/paste shortcut enable
    config.disable_default_key_bindings = true
    config.key_tables = {}
    config.keys = {
      { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo "Clipboard" },
      { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom "Clipboard" },
    }
end

return M
