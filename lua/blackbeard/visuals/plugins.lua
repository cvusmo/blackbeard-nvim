-- ~/blackbeard-nvim/blackbeard/visuals/plugins.lua

local M = {}

---@param colors BlackbeardColors
---@param config? BlackbeardConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("blackbeard").config

    return {
        GitSignsAdd = { fg = theme.vcs.added, bg = theme.ui.bg_gutter },
        GitSignsChange = { fg = theme.vcs.changed, bg = theme.ui.bg_gutter },
        -- Add more plugin-related highlights here
    }
end

return M

