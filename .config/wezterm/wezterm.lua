-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

require('common').apply_to(config)

if os.getenv("SWAYSOCK") then
    require('profiles.sway').apply_to(config)
end

if os.getenv("HYPRLAND_INSTANCE_SIGNATURE") then
    require('profiles.hyprland').apply_to(config)
end

-- Finally, return the configuration to wezterm:
return config
