-- ~/blackbeard-nvim/blackbeard/visuals/lsp.lua

local M = {}

---@param colors BlackbeardColors
---@param config? BlackbeardConfig
function M.setup(colors, config)
    local theme = colors.theme
    config = config or require("blackbeard").config

    return {
        DiagnosticError = { fg = theme.diag.error },
        DiagnosticWarn = { fg = theme.diag.warning },
        DiagnosticInfo = { fg = theme.diag.info },
        LspReferenceText = { bg = theme.diff.text },
        -- Add more LSP-related highlights here
    }
end

return M

