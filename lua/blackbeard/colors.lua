-- ~/blackbeard-nvim/lua/blackbeard/colors.lua

local M = {}

-- Define the color palette to match Alacritty's colors
local palette = {
    -- Primary Colors
    bg = '#1C1B1A',          -- Deep retro brown (background)
    fg = '#F4E3C1',          -- Warm retro cream (foreground)

    -- Cursor Colors
    cursor_dark_text = '#3B3836', -- Matches background
    cursor = '#F24935',      -- Retro orange

    -- Selection Colors
    selection_text = '#1C1B1A', -- Matches background
    selection_bg = '#F4BC59',   -- Muted orange highlight

    -- Normal Colors
    black = '#1C1B1A',       -- Deep retro brown
    red = '#D13438',         -- Vibrant retro red
    green = '#73A857',       -- Muted avocado green
    blue = '#5A8CA5',        -- Soft retro teal
    yellow = '#F1C232',      -- Golden mustard
    magenta = '#A066C9',     -- Soft lavender purple
    cyan = '#46B9A0',        -- Mint green
    white = '#F4E3C1',       -- Warm retro cream
    orange = '#F27835',
    brown = '#372809',

    -- Bright Colors
    brblack = '#454240',     -- Softer deep brown
    brred = '#FF5F56',       -- Vibrant coral red
    brgreen = '#88C070',     -- Bright retro lime
    brblue = '#73B3D8',      -- Light retro teal
    bryellow = '#FADF60',    -- Bright golden yellow
    brmagenta = '#B794F4',   -- Pastel lilac
    --brcyan = '#6FE2CA',      -- Bright aqua green
    brcyan = '#B966C9',
    brwhite = '#FAF2E2',     -- creamy white?
    brorange = '#F4A259',
    brbrown = '#928873',
}

-- Function to set up the colors, allowing user overrides
function M.setup(custom_colors)
    -- Merge default palette with custom colors
    return vim.tbl_deep_extend("force", palette, custom_colors or {})
end

return M
