-- /cvusmo/blackbeard-nvim/lua/blackbeard/light-mode.lua

local M = {
  bg = "#F4E3C1", -- Background (light beige, unchanged)
  fg = "#1C1B1A", -- Foreground (dark gray, unchanged, good contrast)
  cursor = "#D13438", -- Cursor (changed to red for better visibility)
  selection_bg = "#F4A259", -- Selection background (orange, unchanged)
  selection_fg = "#1C1B1A", -- Selection foreground (dark gray, unchanged)
  black = "#454240", -- Dark gray (unchanged)
  red = "#A61B1E", -- Darker red for better contrast (was #D13438)
  green = "#5A8C3A", -- Darker green for better contrast (was #88C070)
  yellow = "#C89F27", -- Darker yellow for better contrast (was #F1C232)
  blue = "#3A6A85", -- Darker blue for better contrast (was #5A8CA5)
  magenta = "#7A4A9A", -- Darker magenta for better contrast (was #A066C9)
  cyan = "#3A6A85", -- Match blue for consistency (was #5A8CA5)
  white = "#7A6E57", -- Darker white for better contrast (was #AA9E87)
  brblack = "#614A4D", -- Unchanged
  brred = "#C72A2D", -- Darker bright red (was #FF5F56)
  brgreen = "#6A9E4A", -- Darker bright green (was #88C070)
  bryellow = "#E0B53A", -- Darker bright yellow (was #FADF60)
  brblue = "#4A8AB5", -- Darker bright blue (was #73B3D8)
  brmagenta = "#9A6AD4", -- Darker bright magenta (was #B794F4)
  brcyan = "#4A9EB5", -- Darker bright cyan (was #6FE2CA)
  brwhite = "#D9C9A9", -- Slightly darker bright white (was #F6E8CD)
}
return M
