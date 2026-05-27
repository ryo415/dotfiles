-----------------
-- AUTOSTART   --
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
		hl.exec_cmd("hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

		-- notification
		hl.exec_cmd("mako")

		-- idle / lock
    -- hl.exec_cmd("hypridle")
end)
