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
        -- Basic UI Elements
        Normal = {
            fg = palette.brblack,
            bg = palette.fg,
        },
        CursorLine = {
            bg = palette.blue,
        },
        LineNr = {
            fg = palette.red,
        },
        CursorLineNr = {
            fg = palette.black,
            bold = true,
        },
        StatusLine = {
            fg = palette.black,
            bg = palette.fg,
        },
        StatusLineNC = {
            fg = palette.brblack,
            bg = palette.fg,
        },
        VertSplit = {
            fg = palette.brblack,
        },
        Pmenu = {
            fg = palette.black,
            bg = palette.brblack,
        },
        PmenuSel = {
            fg = palette.bg,
            bg = palette.black,
        },
        Visual = {
            bg = palette.blue,
        },

        -- Syntax Highlighting
        Comment = {
            fg = palette.magenta,
            italic = true,
        },
        Constant = {
            fg = palette.black,
        },
        String = {
            fg = palette.red,
        },
        Character = {
            fg = palette.black,
        },
        Number = {
            fg = palette.red,
        },
        Boolean = {
            fg = palette.blue,
            bold = true,
        },
        Identifier = {
            fg = palette.blue,
        },
        Function = {
            fg = palette.red,
            bold = true,
        },
        Statement = {
            fg = palette.magenta,
            bold = true,
        },
        Conditional = {
            fg = palette.magenta,
        },
        Repeat = {
            fg = palette.magenta,
        },
        Label = {
            fg = palette.red,
        },
        Operator = {
            fg = palette.black,
        },
        Keyword = {
            fg = palette.red,
            bold = true,
        },
        Exception = {
            fg = palette.red,
        },

        -- NeoTree and File Explorer
        NeoTreeDirectoryName = {
            fg = palette.black,
            bold = true,
        },
        NeoTreeDirectoryIcon = {
            fg = palette.blue,
        },
        NeoTreeFileName = {
            fg = palette.brblack,
        },
        NeoTreeFileNameOpened = {
            fg = palette.red,
            bold = true,
        },

        -- Diagnostics
        DiagnosticError = {
            fg = palette.red,
        },
        DiagnosticWarn = {
            fg = palette.magenta,
        },
        DiagnosticInfo = {
            fg = palette.blue,
        },
        DiagnosticHint = {
            fg = palette.black,
        },

        -- Other UI Elements
        SignColumn = {
            fg = palette.brblack,
        },
        CursorColumn = {
            bg = palette.bg,
        },
        Folded = {
            fg = palette.brblack,
            bg = palette.fg,
        },
    }
end

return M
