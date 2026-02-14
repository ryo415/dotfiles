-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- or, changing the font size and color scheme.
-- color scheme ref: https://wezterm.org/colorschemes/
config.font_size = 12
config.color_scheme = 'iTerm2 Default'

config.window_background_opacity = 0.90
config.window_decorations = "RESIZE"

-- keybinds
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

-- Finally, return the configuration to wezterm:
return config
