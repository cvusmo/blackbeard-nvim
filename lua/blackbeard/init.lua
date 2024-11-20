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
    compile = false,
    colors = {},  -- We'll set this later, after loading the theme
}

--- Update global configuration with user settings
---@param config? table User configuration
function M.setup(config)
    -- Merge the user config with default config
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    -- Set up colors and load the theme after setup
    local theme = M.config.theme
    -- Now set the theme colors after the config is merged
    M.config.colors = require("blackbeard.colors").setup()

    -- Load the theme
    M.load(theme)
end

--- Load the colorscheme based on the current theme
---@param theme? string
function M.load(theme)
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
    local colors = M.config.colors

    -- Apply the light or dark theme
    local theme_function = require("blackbeard.themes")[theme]
    if theme_function then
        local theme_colors = theme_function(colors)
        M.apply_highlights(theme_colors)
    else
        vim.notify("Blackbeard: Invalid theme specified, falling back to default theme.", vim.log.levels.WARN)
    end
end

--- Apply highlights using theme colors
---@param theme_colors table
function M.apply_highlights(theme_colors)
    for group, settings in pairs(theme_colors) do
        local highlight_cmd = "highlight " .. group
        if settings.fg then
            highlight_cmd = highlight_cmd .. " guifg=" .. settings.fg
        end
        if settings.bg then
            highlight_cmd = highlight_cmd .. " guibg=" .. settings.bg
        end
        if settings.italic then
            highlight_cmd = highlight_cmd .. " gui=italic"
        end
        if settings.bold then
            highlight_cmd = highlight_cmd .. " gui=bold"
        end
        vim.cmd(highlight_cmd)
    end
end

return M
