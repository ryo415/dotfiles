-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Check execution environment
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_macos = wezterm.target_triple:find("apple%-darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_sway = os.getenv("SWAYSOCK") ~= nil
local is_hyprland = os.getenv("HYPRLAND_INSTANCE_SIGNATURE") ~= nil

require('common').apply_to(config)

if is_windows then
  require('profiles.windows').apply_to(config)
elseif is_macos then
  require('profiles.macos').apply_to(config)
elseif is_linux then
  require('profiles.linux').apply_to(config)
  if is_sway then
    require('profiles.sway').apply_to(config)
  elseif is_hyprland then
    require('profiles.hyprland').apply_to(config)
  end
end

-- Finally, return the configuration to wezterm:
return config
