local M = {}

function M.apply_to(config)
    config.enable_tab_bar = true
    config.hide_tab_bar_if_only_one_tab = true

    config.window_background_opacity = 0.95
    config.window_decorations = "NONE"
end

return M
