-- ~/blackbeard-nvim/lua/blackbeard/init.lua

local M = {}

M.config = {
    -- General Settings
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,
    dimInactive = false,
    terminalColors = true,
    -- Theme settings
    theme = "dark",  -- Default theme can be "dark" or "light"
    compile = false,  -- Whether to compile the theme
}

--- Update global configuration with user settings
---@param config? BlackbeardConfig User configuration
function M.setup(config)
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    -- Load the theme after setup
    M.load(M.config.theme)
end

--- Load the colorscheme based on the current theme
---@param theme? string
function M.load(theme)
    local utils = require("blackbeard.utils")

    -- Get the theme from the config or default
    theme = theme or M.config.theme
    M._CURRENT_THEME = theme

    -- Clear existing highlights if there is a colorscheme
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end

    -- Set the colorscheme name
    vim.g.colors_name = "blackbeard"
    vim.o.termguicolors = true

    -- Load the colors using the correct theme
    local colors = require("blackbeard.colors").setup(M.config.colors)
    local highlights = require("blackbeard.highlights").setup(colors, M.config)
    require("blackbeard.highlights").highlight(highlights, M.config.terminalColors and colors.theme.term or {})

    -- Apply the light or dark theme
    local theme_function = require("blackbeard.themes")[theme]
    if theme_function then
        local theme_colors = theme_function(colors)
        M.apply_highlights(theme_colors)
    else
        vim.notify("Blackbeard: Invalid theme specified, falling back to default theme.", vim.log.levels.WARN)
    end
end

return M
