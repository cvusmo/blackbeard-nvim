-- ~/blackbeard-nvim/lua/blackbeard/utils.lua

local M = {}

-- Helper to handle transparency in the theme
function M.handle_transparency(is_transparent)
    if is_transparent then
        vim.cmd("hi Normal guibg=NONE")
    end
end

-- Function to merge user colors with the default palette
function M.merge_colors(palette, custom_colors)
    return vim.tbl_deep_extend("force", palette, custom_colors or {})
end

return M
