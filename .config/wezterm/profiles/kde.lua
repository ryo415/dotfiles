local M = {}

function M.apply_to(config)
    config.enable_tab_bar = false

    inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.7,
    }
end

return M
