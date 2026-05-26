--  _   _                  _                 _
-- | | | |_   _ _ __  _ __| | __ _ _ __   __| |
-- | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
-- |  _  | |_| | |_) | |  | | (_| | | | | (_| |
-- |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
--        |___/|_|
--
-- -----------------------------------------------------
-- Hyprland 0.55+ Lua config.
-- Legacy hyprland.conf is kept for reference, but Hyprland prefers this file.

--------------
-- SOURCES  --
--------------

local config_dir = os.getenv("HOME") .. "/.config/hypr/config.d"
package.path = config_dir .. "/?.lua;" .. package.path

require("00-vars")
require("10-monitor")
require("20-input")
require("30-keybinds")
require("40-rules")
require("50-layout")
require("60-appearance")
require("90-autostart")
