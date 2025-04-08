-- /cvusmo/blackbeard-nvim/lua/blackbeard/themes.lua

local M = {}

M.dark = function(colors)
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    Directory = { fg = colors.blue },
    Function = { fg = colors.red },
    Identifier = { fg = colors.yellow },
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
    LineNr = { fg = colors.brblack },
    CursorLineNr = { fg = colors.brwhite, bold = true },
    Visual = { fg = colors.selection_fg, bg = colors.selection_bg },
    Search = { fg = colors.bg, bg = colors.yellow },
    IncSearch = { fg = colors.bg, bg = colors.bryellow },
  }
end

M.light = function(colors)
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    Directory = { fg = colors.blue },
    Function = { fg = colors.red },
    Identifier = { fg = colors.green },
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
    LineNr = { fg = colors.brblack },
    CursorLineNr = { fg = colors.brwhite, bold = true },
    Visual = { fg = colors.selection_fg, bg = colors.selection_bg },
    Search = { fg = colors.bg, bg = colors.yellow },
    IncSearch = { fg = colors.bg, bg = colors.bryellow },
  }
end

return M
