-- ~/cvusmo/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

-- Dark Theme
M.dark = function(palette)
    return {
        Normal = {
            fg = palette.brbrown,
            bg = palette.bg,
        },
        Directory = {
            fg = palette.brbrown,
        },
        Function = {
            fg = palette.red,
        },
        Identifier = {
            fg = palette.yellow,
        },
        Keyword = {
            fg = palette.orange,
        },
        -- NeoTree and File Explorer
        NeoTreeDirectoryName = {
            fg = palette.brorange,
            bold = true,
        },
        NeoTreeFileName = {
            fg = palette.brwhite,
        },
        NeoTreeFileNameOpened = {
          fg = palette.orange,
        },
    }
end

-- Light Theme
M.light = function(palette)
    return {
        Normal = {
            fg = palette.brblack,
            bg = palette.brwhite,
        },
        FloatTitle = {
          fg = palette.black,
        },
        CursorLine = {
            bg = palette.blue,
        },
        LineNr = {
            fg = palette.green,
        },
        CursorLineNr = {
            fg = palette.black,
            bold = true,
        },
        Directory = {
          fg = palette.black,
        },
        Folded = {
          fg = palette.cursor,
        },
        Comment = {
            fg = palette.brgreen,
            italic = true,
        },
        Constant = {
            fg = palette.black,
        },
        String = {
          fg = palette.brblack,
        },
        Function = {
            fg = palette.red,
            bold = true,
        },
        Variable = {
          fg = palette.black,
        },
        TSVariable = {
          fg = palette.black,
        },
        TSFunction = {
          fg = palette.red,
          bold = true,
        },
        Identifier = {
          fg = palette.cyan,
        },
        Keyword = {
            fg = palette.brblack,
            bold = true,
        },
        ErrorMsg = {
          fg = palette.red,
          bold = true,
        },
        WarningMsg = {
          fg = palette.magenta,
          bold = true,
          italic = true,
        },
        Type = {
            fg = palette.blue,
            bold = true,
        },
        Statement = {
            fg = palette.brblack,
            bold = true,
        },
        Operator = {
            fg = palette.black,
        },
        Delimiter = {
            fg = palette.brblack,
        },
        Special = {
            fg = palette.red,
            bold = true,
        },

        -- LSP and Diagnostics
        LspReferenceText = {
            bg = palette.blue,
        },
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

        -- NeoTree and File Explorer
        NeoTreeDirectoryName = {
            fg = palette.black,
            bold = true,
        },
        NeoTreeFileName = {
            fg = palette.brblack,
        },
        NeoTreeFileNameOpened = {
          fg = palette.brblack,
        },
    }
end

-- Avocado Theme
M.avocado = function(palette)
    return {
        Normal = {
            fg = palette.fg,
            bg = palette.bg,
        },
        Comment = {
            fg = palette.blue,
            italic = true,
        },
        Constant = {
            fg = palette.orange,
        },
        Variable = {
            fg = palette.brorange,
        },
        Function = {
            fg = palette.brred,
        },
        Identifier = {
            fg = palette.red,
        },
        LineNr = {
            fg = palette.green,
        },
        Directory = {
            fg = palette.brown,
        },
    }
end

return M
