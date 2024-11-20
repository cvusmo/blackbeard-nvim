-- ~/blackbeard-nvim/lua/blackbeard/init.lua

local M = {}

---@alias ColorSpec string RGB Hex string
---@alias ColorTable table<string, ColorSpec>
---@alias BlackbeardColorsSpec { palette: ColorTable, theme: ColorTable }
---@alias BlackbeardColors { palette: PaletteColors, theme: ThemeColors }

--- Default config
---@class BlackbeardConfig
M.config = {
    -- General Settings
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,
    dimInactive = false,
    terminalColors = true,

    -- Colors settings 
    colors = { theme = {}, palette = {} },

    ---@type fun(colors: BlackbeardColorsSpec): table<string, table>
    overrides = function()
        return {}
    end,

    ---@type { dark: string, light: string }
    background = { dark = "dark", light = "light" },
    theme = "dark",
    compile = false,
}

local function check_config(config)
    -- Ensure config is valid, otherwise default config is used
    local err
    return not err
end

--- Update global configuration with user settings
---@param config? BlackbeardConfig User configuration
function M.setup(config)
    if check_config(config) then
        M.config = vim.tbl_deep_extend("force", M.config, config or {})
    else
        vim.notify("Blackbeard: Errors found while loading user config. Using default config.", vim.log.levels.ERROR)
    end
end

--- Load the colorscheme based on the current theme
---@param theme? string
function M.load(theme)
    local utils = require("blackbeard.utils")

    -- Get the theme from the config or default
    theme = theme or M.config.background[vim.o.background] or M.config.theme
    M._CURRENT_THEME = theme

    -- Clear existing highlights if there is a colorscheme
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end

    -- Set the colorscheme name
    vim.g.colors_name = "blackbeard"
    vim.o.termguicolors = true

    -- Compile and load compiled theme if enabled
    if M.config.compile then
        if utils.load_compiled(theme) then
            return
        end

        M.compile()
        utils.load_compiled(theme)
    else
        -- Set up colors using the colors setup from `colors.lua`
        local colors = require("blackbeard.colors").setup(M.config.colors)
        local highlights = require("blackbeard.highlights").setup(colors, M.config)
        require("blackbeard.highlights").highlight(highlights, M.config.terminalColors and colors.theme.term or {})
    end
end

--- Compile the themes
function M.compile()
    for theme, _ in pairs(require("blackbeard.themes")) do
        local colors = require("blackbeard.colors").setup(M.config.colors)
        local highlights = require("blackbeard.highlights").setup(colors, M.config)
        require("blackbeard.utils").compile(theme, highlights, M.config.terminalColors and colors.theme.term or {})
    end
end

-- Command to compile the theme
vim.api.nvim_create_user_command("BlackbeardCompile", function()
    for mod, _ in pairs(package.loaded) do
        if mod:match("^blackbeard%.") then
            package.loaded[mod] = nil
        end
    end
    M.compile()
    vim.notify("Blackbeard: compiled successfully!", vim.log.levels.INFO)
    M.load(M._CURRENT_THEME)
    vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
end, {})

return M
