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
            bg = palette.white,
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
        Search = {
            fg = palette.bg,
            bg = palette.blue,
            bold = true,
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
            fg = palette.brblack,
        },
        Character = {
            fg = palette.black,
        },
        Number = {
            fg = palette.cursor,
        },
        Boolean = {
            fg = palette.red,
            bold = true,
        },
        Function = {
            fg = palette.red,
            bold = true,
        },
        Statement = {
            fg = palette.brblack,
            bold = true,
        },
        Conditional = {
            fg = palette.brblack,
        },
        Repeat = {
            fg = palette.magenta,
        },
        Label = {
            fg = palette.brblack,
        },
        Operator = {
            fg = palette.black,
        },
        Keyword = {
            fg = palette.brblack,
            bold = true,
        },
        Exception = {
            fg = palette.red,
        },
        Type = {
            fg = palette.brblack,
            bold = true,
        },
        Structure = {
            fg = palette.brblack,
        },
        Typedef = {
            fg = palette.black,
        },
        Include = {
            fg = palette.red,
            bold = true,
        },
        PreProc = {
            fg = palette.magenta,
        },
        Special = {
            fg = palette.red,
            bold = true,
        },
        SpecialChar = {
            fg = palette.green,
        },
        Tag = {
            fg = palette.red,
            bold = true,
        },
        Delimiter = {
            fg = palette.brblack,
        },
        SpecialComment = {
            fg = palette.magenta,
            italic = true,
        },
        Todo = {
            fg = palette.red,
            bold = true,
            italic = true,
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
            fg = palette.black,
            bold = true,
        },
        NeoTreeIndentMarker = {
            fg = palette.brblack,
        },
        NeoTreeGitModified = {
            fg = palette.cyan,
        },
        NeoTreeGitAdded = {
            fg = palette.green,
        },
        NeoTreeGitDeleted = {
            fg = palette.magenta,
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
        DiffAdd = {
            fg = palette.green,
            bg = palette.bg,
        },
        DiffChange = {
            fg = palette.blue,
            bg = palette.bg,
        },
        DiffDelete = {
            fg = palette.red,
            bg = palette.bg,
        },
        DiffText = {
            fg = palette.brblack,
            bold = true,
        },
        FoldColumn = {
            fg = palette.brblack,
        },
        QuickFixLine = {
            fg = palette.red,
            bold = true,
        },
    }
end

-- Avocado Theme
M.avocado = function(palette)
    return {
        -- Basic UI Elements
        Normal = {
            fg = palette.brblack,
            bg = palette.green,
        },
        CursorLine = {
            bg = palette.blue,
        },
        LineNr = {
            fg = palette.white,
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
        Search = {
            fg = palette.bg,
            bg = palette.blue,
            bold = true,
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
            fg = palette.brblack,
        },
        Character = {
            fg = palette.black,
        },
        Number = {
            fg = palette.cursor,
        },
        Boolean = {
            fg = palette.red,
            bold = true,
        },
        Identifier = {
            fg = palette.black,
        },
        Function = {
            fg = palette.red,
            bold = true,
        },
        Statement = {
            fg = palette.brblack,
            bold = true,
        },
        Conditional = {
            fg = palette.brblack,
        },
        Repeat = {
            fg = palette.magenta,
        },
        Label = {
            fg = palette.brblack,
        },
        Operator = {
            fg = palette.black,
        },
        Keyword = {
            fg = palette.brblack,
            bold = true,
        },
        Exception = {
            fg = palette.red,
        },
        Type = {
            fg = palette.brblack,
            bold = true,
        },
        Structure = {
            fg = palette.brblack,
        },
        Typedef = {
            fg = palette.black,
        },
        Include = {
            fg = palette.red,
            bold = true,
        },
        PreProc = {
            fg = palette.magenta,
        },
        Special = {
            fg = palette.red,
            bold = true,
        },
        SpecialChar = {
            fg = palette.white,
        },
        Tag = {
            fg = palette.red,
            bold = true,
        },
        Delimiter = {
            fg = palette.brblack,
        },
        SpecialComment = {
            fg = palette.magenta,
            italic = true,
        },
        Todo = {
            fg = palette.red,
            bold = true,
            italic = true,
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
            fg = palette.black,
            bold = true,
        },
        NeoTreeIndentMarker = {
            fg = palette.brblack,
        },
        NeoTreeGitModified = {
            fg = palette.cyan,
        },
        NeoTreeGitAdded = {
            fg = palette.white,
        },
        NeoTreeGitDeleted = {
            fg = palette.magenta,
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
        DiffAdd = {
            fg = palette.white,
            bg = palette.bg,
        },
        DiffChange = {
            fg = palette.blue,
            bg = palette.bg,
        },
        DiffDelete = {
            fg = palette.red,
            bg = palette.bg,
        },
        DiffText = {
            fg = palette.brblack,
            bold = true,
        },
        FoldColumn = {
            fg = palette.brblack,
        },
        QuickFixLine = {
            fg = palette.red,
            bold = true,
        },
    }
end


return M
