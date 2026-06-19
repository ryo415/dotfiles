-----------------
-- AUTOSTART   --
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("~/.config/hypr/scripts/monitor-layout.sh")
end)
