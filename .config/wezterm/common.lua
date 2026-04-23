local wezterm = require 'wezterm'
local M = {}

function M.apply_to(config)
    -- This is where you actually apply your config choices.

    -- or, changing the font size and color scheme.
    -- color scheme ref: https://wezterm.org/colorschemes/
    config.font_size = 12
    config.color_scheme = 'iTerm2 Default'

    config.window_background_opacity = 0.90
    config.window_decorations = "RESIZE"
    config.font = wezterm.font("FiraCode Nerd Font", {weight="Regular", stretch="Normal", style="Normal"})

    -- keybinds
    config.keys = require("keybinds").keys
    config.key_tables = require("keybinds").key_tables
end

return M
