-- /cvusmo/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

M.dark = function(colors)
    return {
        Normal = { fg = colors.fg, bg = colors.bg },
        Directory = { fg = colors.blue },
        Function = { fg = colors.red },
        Identifier = { fg = colors.yellow },
    }
end

M.light = function(colors)
    return {
        Normal = { fg = colors.fg, bg = colors.bg },
        Directory = { fg = colors.blue },
        Function = { fg = colors.red },
        Identifier = { fg = colors.green },
    }
end

return M
