-- ~/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

-- Dark Theme
M.dark = function(palette)
    return {
        ui = {
            fg = palette.fg,
            bg = palette.bg,
        },
        syn = {
            comment = palette.brblue,
            constant = palette.cyan,
            identifier = palette.yellow,
        },
    }
end

-- Light Theme
M.light = function(palette)
    return {
        ui = {
            fg = palette.bg,   -- Light background color
            bg = palette.fg,   -- Light foreground color
        },
        syn = {
            comment = palette.bryellow,
            constant = palette.bryellow,
            identifier = palette.bryellow,
        },
    }
end

return M
