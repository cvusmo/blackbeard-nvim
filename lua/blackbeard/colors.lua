-- ~/cvusmo/blackbeard-nvim/blackbeard/lua/colors.lua

-- colors.lua

local M = {}

M.palette = {
    -- Primary Colors
    bg = "#1C1B1A",        -- Background
    fg = "#F4E3C1",        -- Foreground
    cursor = "#F27835",    -- Cursor color
    selection_bg = "#F4A259", -- Selection background
    selection_fg = "#1C1B1A", -- Selection text

    -- Normal ANSI Colors
    black = "#454240",     -- ANSI 030
    red = "#D13438",       -- ANSI 031
    green = "#73A857",     -- ANSI 032
    yellow = "#F1C232",    -- ANSI 033
    blue = "#5A8CA5",      -- ANSI 034
    magenta = "#A066C9",   -- ANSI 035
    cyan = "#46B9A0",      -- ANSI 036
    white = "#AA9E87",     -- ANSI 037

    -- Bright ANSI Colors
    brblack = "#614A4D",   -- ANSI 090
    brred = "#FF5F56",     -- ANSI 091
    brgreen = "#88C070",   -- ANSI 092
    bryellow = "#FADF60",  -- ANSI 093
    brblue = "#73B3D8",    -- ANSI 094
    brmagenta = "#B794F4", -- ANSI 095
    brcyan = "#6FE2CA",    -- ANSI 096
    brwhite = "#F6E8CD",   -- ANSI 097
}

return M
