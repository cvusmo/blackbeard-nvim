-- ~/blackbeard-nvim/blackbeard/visuals/syntax.lua

local M = {}

---@param colors BlackbeardColors
---@param config? BlackbeardConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("blackbeard").config

    return {
        Comment = vim.tbl_extend("force", { fg = theme.syn.comment }, config.commentStyle),
        Constant = { fg = theme.syn.constant },
        String = { fg = theme.syn.string },
        Number = { fg = theme.syn.number },
        Keyword = vim.tbl_extend("force", { fg = theme.syn.keyword }, config.keywordStyle),
        Function = vim.tbl_extend("force", { fg = theme.syn.fun }, config.functionStyle),
        -- Add more syntax-related highlights here
    }
end

return M

