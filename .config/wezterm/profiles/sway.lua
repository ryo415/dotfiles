local M = {}

function M.apply_to(config)
    -- if VM environment, configure "Software" in config.front_end
    config.front_end = "Software"
    config.enable_tab_bar = false
end

return M
