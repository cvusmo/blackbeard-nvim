-- ~/blackbeard-nvim/lua/blackbeard/init.lua

local M = {}
local alacritty = require("blackbeard.alacritty")

M.config = {
    theme = "dark",  -- Default theme
    colors = {},     -- Will be set based on the theme
}

function M.setup(config)
    -- Merge user-provided configuration with defaults
    M.config = vim.tbl_deep_extend("force", M.config, config or {})
    M.config.colors = require("blackbeard.colors").setup()

    -- Automatically load the theme and update applications
    M.load(M.config.theme)
end

function M.load(theme)
    theme = theme or M.config.theme
    M.config.colors = require("blackbeard.colors").setup()

    -- Apply highlights
    local theme_function = require("blackbeard.themes")[theme]
    if theme_function then
        local theme_colors = theme_function(M.config.colors)
        M.apply_highlights(theme_colors)

        -- Automatically update Alacritty theme
        alacritty.update_theme(M.config.colors)
    else
        vim.notify("Blackbeard: Invalid theme specified.", vim.log.levels.ERROR)
    end
end

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
