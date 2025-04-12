-- ~/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

M.dark = function(colors)
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    Directory = { fg = colors.blue },
    Function = { fg = colors.red },
    Identifier = { fg = colors.brown },
    Comment = { fg = colors.brblack, italic = true },
    String = { fg = colors.green },
    Keyword = { fg = colors.magenta },
    Statement = { fg = colors.magenta },
    Constant = { fg = colors.cyan },
    Number = { fg = colors.cyan },
    Operator = { fg = colors.brwhite },
    PreProc = { fg = colors.red },
    Type = { fg = colors.blue },
    Special = { fg = colors.bryellow },
    Error = { fg = colors.red, bg = colors.bg, bold = true },
    Todo = { fg = colors.magenta, bg = colors.bg, bold = true },
    LineNr = { fg = colors.green },
    CursorLineNr = { fg = colors.brwhite, bold = true },
    Visual = { fg = colors.selection_fg, bg = colors.selection_bg },
    Search = { fg = colors.bg, bg = colors.yellow },
    IncSearch = { fg = colors.bg, bg = colors.bryellow },
    Folded = { fg = colors.brblack, bg = colors.bryellow }, -- Darker foreground on light yellow background
  }
end

M.light = function(colors)
  return {
    Normal = { fg = colors.fg, bg = colors.bg }, -- fg = #1C1B1A, bg = #F4E3C1
    Directory = { fg = colors.green },
    Function = { fg = colors.red },
    Identifier = { fg = colors.brown },
    Comment = { fg = colors.brblack, italic = true },
    String = { fg = colors.green },
    Keyword = { fg = colors.magenta },
    Statement = { fg = colors.magenta },
    Constant = { fg = colors.brown },
    Number = { fg = colors.green },
    Operator = { fg = colors.brwhite },
    PreProc = { fg = colors.red },
    Type = { fg = colors.blue },
    Special = { fg = colors.bryellow },
    Error = { fg = colors.red, bg = colors.bg, bold = true },
    Todo = { fg = colors.magenta, bg = colors.bg, bold = true },
    LineNr = { fg = colors.brblack },
    CursorLineNr = { fg = colors.brwhite, bold = true },
    Visual = { fg = colors.selection_fg, bg = colors.selection_bg },
    Search = { fg = colors.bg, bg = colors.yellow },
    IncSearch = { fg = colors.bg, bg = colors.bryellow },
    -- UI elements
    Pmenu = { fg = colors.fg, bg = colors.white }, -- Popup menu background (e.g., command bar, completion)
    PmenuSel = { fg = colors.bg, bg = colors.yellow }, -- Selected item in popup menu
    StatusLine = { fg = colors.fg, bg = colors.white }, -- Active status line
    StatusLineNC = { fg = colors.brblack, bg = colors.white }, -- Inactive status line
    WildMenu = { fg = colors.bg, bg = colors.yellow }, -- Command-line completion menu
    VertSplit = { fg = colors.white, bg = colors.white }, -- Window separator
    Folded = { fg = colors.brblack, bg = colors.bryellow }, -- Darker foreground on light brown background
  }
end

return M
