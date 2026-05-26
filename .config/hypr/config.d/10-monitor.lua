----------------
-- MONITORS   --
----------------

hl.monitor({
    output = "HDMI-A-2",
    mode = "1920x1080@60.0000",
    position = "1920x0",
    scale = 1,
})

hl.monitor({
    output = "DP-5",
    mode = "1920x1080@60.00000",
    position = "0x0",
    scale = 1,
})

------------------
-- WORKSPACES   --
------------------

-- Right monitor: main work area
for i = 1, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-2",
        default = i == 1,
    })
end

-- Left monitor: secondary area for media and games
for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-5",
        default = i == 6,
    })
end
