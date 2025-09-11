-- ~/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

M.dark = function(colors)
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.brblack, bold = false }, -- Darker background for contrast
    FloatBorder = { fg = colors.brgreen, bg = colors.brblack }, -- Green border on dark background
    Directory = { fg = colors.blue },
    Function = { fg = colors.red },
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
    Folded = { fg = colors.brblack, bg = colors.bryellow },
  }
end

M.light = function(colors)
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.brwhite, bold = false }, -- Lighter background for contrast
    FloatBorder = { fg = colors.brgreen, bg = colors.brwhite }, -- Green border on light background
    Directory = { fg = colors.green },
    Function = { fg = colors.red },
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
    Pmenu = { fg = colors.fg, bg = colors.white },
    PmenuSel = { fg = colors.bg, bg = colors.yellow },
    StatusLine = { fg = colors.fg, bg = colors.white },
    StatusLineNC = { fg = colors.brblack, bg = colors.white },
    WildMenu = { fg = colors.bg, bg = colors.yellow },
    VertSplit = { fg = colors.white, bg = colors.white },
    Folded = { fg = colors.brblack, bg = colors.bryellow },
    Cmdline = { fg = colors.fg, bg = colors.white },
    MsgArea = { fg = colors.black, bg = colors.white },
    MsgSeparator = { fg = colors.black, bg = colors.white },
  }
end

return M
