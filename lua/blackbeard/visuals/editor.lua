-- ~/blackbeard-nvim/blackbeard/visuals/editor.lua

local M = {}

---@param colors BlackbeardColors
---@param config? BlackbeardConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("blackbeard").config

    return {
        Cursor = { fg = theme.ui.bg, bg = theme.ui.fg },
        CursorLine = { bg = theme.ui.bg_p2 },
        LineNr = { fg = theme.ui.nontext, bg = theme.ui.bg_gutter },
        ErrorMsg = { fg = theme.diag.error },
        -- Add more editor-related highlights here
    }
end

return M

