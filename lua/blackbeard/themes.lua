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
        CursorLine {
          fg = palette.brblack,
        },
        LineNr {
          fg = palette.red,
        },
        
        Comment = {
            fg = palette.brblack,,
            italic = true,
        },
        Constant = {
            fg = palette.black,
        },
        Identifier = {
            fg = palette.selection_bg,
        },
    }
end

return M
