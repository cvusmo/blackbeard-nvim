-- /cvusmo/blackbeard-nvim/lua/blackbeard/init.lua

local M = {}
local alacritty = require("blackbeard.alacritty")

M.config = {
    theme = "dark", -- Default theme
}

function M.setup(config)
    -- Merge user-provided configuration with defaults
    M.config = vim.tbl_deep_extend("force", M.config, config or {})
    
    -- Load the initial theme
    M.load(M.config.theme)
end

function M.load(theme)
    theme = theme or M.config.theme
    M.config.theme = theme

    -- Load colors directly from dark-mode.lua or light-mode.lua
    local colors = require("blackbeard." .. theme .. "-mode")

    if not colors then
        vim.notify("Blackbeard: Invalid theme specified: " .. theme, vim.log.levels.ERROR)
        return
    end

    -- Apply Neovim highlights for the selected theme
    local theme_function = require("blackbeard.themes")[theme]
    if theme_function then
        local neovim_colors = theme_function(colors)
        M.apply_highlights(neovim_colors)
        
        -- Update Alacritty with the current theme's colors
        alacritty.update_theme(theme)
    else
        vim.notify("Blackbeard: Theme function not found for " .. theme, vim.log.levels.ERROR)
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
