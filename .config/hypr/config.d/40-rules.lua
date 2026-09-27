-------------------------
-- WINDOW RULES        --
-------------------------

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "dashboard-workspace",
    match = { initial_title = "^Quickshell Dashboard$" },
    workspace = "name:dashboard silent",
    tile = true,
    border_size = 0,
})

----------------
-- XWAYLAND   --
----------------

hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
})
