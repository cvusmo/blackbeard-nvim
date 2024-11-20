-- ~/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

-- Dark Theme
M.dark = function(palette)
    return {
        Normal = {
            fg = palette.fg,
            bg = palette.bg,
        },
        Comment = {
            fg = palette.brblue,
            italic = true,
        },
        Constant = {
            fg = palette.cyan,
        },
        Identifier = {
            fg = palette.yellow,
        },
    }
end

-- Light Theme
M.light = function(palette)
    return {
        Normal = {
            fg = palette.brblack,
            bg = palette.fg,
        },
        Comment = {
            fg = palette.red,
            italic = true,
        },
        Constant = {
            fg = palette.blue,
        },
        Identifier = {
            fg = palette.magenta,
        },
    }
end

return M
