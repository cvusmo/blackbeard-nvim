-- ~/cvusmo/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

-- Dark Theme
M.dark = function(palette)
    return {
        Normal = { fg = palette.fg, bg = palette.bg },
        Directory = { fg = palette.blue },
        Function = { fg = palette.red },
        Identifier = { fg = palette.yellow },
    }
end

-- Light Theme
M.light = function(palette)
    return {
        Normal = { fg = palette.brblack, bg = palette.brwhite },
        Directory = { fg = palette.blue },
        Function = { fg = palette.red },
        Identifier = { fg = palette.green },
    }
end

return M
