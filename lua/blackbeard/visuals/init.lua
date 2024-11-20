-- ~/blackbeard-nvim/blackbeard/visuals/init.lua

local M = {}

---@param highlights table
---@param termcolors table
function M.highlight(highlights, termcolors)
    for hl, spec in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl, spec)
    end
    for i, tcolor in ipairs(termcolors) do
        vim.g["terminal_color_" .. i - 1] = tcolor
    end
end

return M
