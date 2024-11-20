-- ~/blackbeard-nvim/blackbeard/visuals/treesitter.lua

local M = {}

---@param colors BlackbeardColors
---@param config? BlackbeardConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("blackbeard").config

    return {
        ["@variable"] = { fg = theme.ui.fg },
        ["@function"] = { fg = theme.syn.fun },
        ["@keyword"] = { fg = theme.syn.keyword },
        ["@comment"] = { fg = theme.syn.comment },
        -- Add more treesitter-related highlights here
    }
end

return M

