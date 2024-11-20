-- ~/blackbeard-nvim/lua/blackbeard/highlights.lua
local M = {}

-- Function to apply the highlights
function M.apply(highlights)
    for group, color in pairs(highlights) do
        vim.cmd(string.format("highlight %s guifg=%s guibg=%s gui=%s", group, color.fg or "NONE", color.bg or "NONE", color.attr or "NONE"))
    end
end

-- Setup function for highlights
function M.setup(colors, config)
    -- Create the highlights based on the theme and user config
    local highlights = {}

    -- Apply the editor-related highlights
    highlights = vim.tbl_deep_extend("force", highlights, require("blackbeard.visuals.editor").setup(colors, config))

    -- Apply the syntax-related highlights
    highlights = vim.tbl_deep_extend("force", highlights, require("blackbeard.visuals.syntax").setup(colors, config))

    -- Apply additional highlight settings like LSP or Treesitter
    highlights = vim.tbl_deep_extend("force", highlights, require("blackbeard.visuals.lsp").setup(colors, config))
    highlights = vim.tbl_deep_extend("force", highlights, require("blackbeard.visuals.plugins").setup(colors, config))
    highlights = vim.tbl_deep_extend("force", highlights, require("blackbeard.visuals.treesitter").setup(colors, config))

    return highlights
end

return M
