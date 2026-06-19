-------------------
-- KEYBINDINGS   --
-------------------

local vars = require("00-vars")

----------------
-- MOVEMENT   --
----------------

local left = "H"
local down = "J"
local up = "K"
local right = "L"
local resizeStep = 40

------------------
-- WINDOW OPS   --
------------------

hl.bind(vars.main_mod .. " + Q", hl.dsp.window.close())
hl.bind(vars.main_mod .. " + M", hl.dsp.exit())
hl.bind(vars.main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(vars.main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(vars.main_mod .. " + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh"))
hl.bind(vars.main_mod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))

-- WINDOW MOVEMENT
hl.bind(vars.main_mod .. " + SHIFT + " .. left, hl.dsp.window.move({ direction = "left" }))
hl.bind(vars.main_mod .. " + SHIFT + " .. right, hl.dsp.window.move({ direction = "right" }))
hl.bind(vars.main_mod .. " + SHIFT + " .. up, hl.dsp.window.move({ direction = "up" }))
hl.bind(vars.main_mod .. " + SHIFT + " .. down, hl.dsp.window.move({ direction = "down" }))
hl.bind(vars.main_mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- WINDOW RESIZE
hl.bind(vars.main_mod .. " + CTRL + " .. left, hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true}))
hl.bind(vars.main_mod .. " + CTRL + " .. right, hl.dsp.window.resize({ x = resizeStep, y = 0, relative = true }))
hl.bind(vars.main_mod .. " + CTRL + " .. up, hl.dsp.window.resize({ x = 0, y = resizeStep, relative = true }))
hl.bind(vars.main_mod .. " + CTRL + " .. down, hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }))
hl.bind(vars.main_mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))


------------------
-- LAUNCH APPS  --
------------------

hl.bind(vars.main_mod .. " + RETURN", hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.main_mod .. " + E", hl.dsp.exec_cmd(vars.file_manager))
hl.bind(vars.main_mod .. " + SPACE", hl.dsp.exec_cmd(vars.app_launcher))
hl.bind(vars.main_mod .. " + SHIFT + B", hl.dsp.exec_cmd(vars.browser))

----------------------
-- FOCUS MOVEMENT   --
----------------------

hl.bind(vars.main_mod .. " + " .. left, hl.dsp.focus({ direction = "left" }))
hl.bind(vars.main_mod .. " + " .. right, hl.dsp.focus({ direction = "right" }))
hl.bind(vars.main_mod .. " + " .. up, hl.dsp.focus({ direction = "up" }))
hl.bind(vars.main_mod .. " + " .. down, hl.dsp.focus({ direction = "down" }))

------------------
-- WORKSPACES   --
------------------

for i = 1, 10 do
    local key = i % 10
    hl.bind(vars.main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(vars.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(vars.main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(vars.main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(vars.main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(vars.main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(vars.main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-----------------------
-- MEDIA / HARDWARE  --
-----------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
