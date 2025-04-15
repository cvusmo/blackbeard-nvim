-- ~/blackbeard-nvim/lua/blackbeard/init.lua
local M = {}
local alacritty = require("blackbeard.alacritty")
local gtk = require("blackbeard.gtk")
local dmenu = require("blackbeard.dmenu")
local waybar = require("blackbeard.waybar")
-- local hyprland = require("blackbeard.hyprland") -- Still commented out
local utils = require("blackbeard.utils")

M.config = {
  theme = "dark",
  font_size = 26,
}

function M.setup(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
  if type(M.config.font_size) ~= "number" or M.config.font_size <= 0 then
    utils.log("Invalid font_size in config; using default (26).", vim.log.levels.WARN, false)
    M.config.font_size = 26
  end

  -- Define components to update when loading a theme
  local components = {
    { "Alacritty", alacritty.update_theme, nil },
    { "GTK", gtk.update_theme, nil },
    { "dmenu", dmenu.update_theme, nil },
    { "Waybar", waybar.update_theme, nil }, -- Add Waybar component
  }

  -- Create user commands
  utils.create_user_commands(function(theme)
    utils.load_theme(theme, M.config, components)
  end, function()
    utils.toggle_theme(utils.get_current_theme(M.config), function(theme)
      utils.load_theme(theme, M.config, components)
    end)
  end, M.config, { alacritty = alacritty, gtk = gtk })

  -- Load the stored theme if it exists, otherwise use the default
  local stored_theme = utils.get_stored_theme()
  local initial_theme = stored_theme or M.config.theme
  local ok, err = pcall(utils.load_theme, initial_theme, M.config, components)
  if not ok then
    utils.log("Failed to load initial theme: " .. tostring(err), vim.log.levels.ERROR, false)
  end

  -- Reapply the Normal highlight group after plugins load to prevent overrides
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local theme = utils.get_current_theme(M.config)
      local colors = require("blackbeard." .. theme .. "-mode")
      local theme_function = require("blackbeard.themes")[theme]
      local neovim_colors = theme_function(colors)
      vim.api.nvim_set_hl(0, "Normal", { fg = neovim_colors.Normal.fg, bg = neovim_colors.Normal.bg })
    end,
  })
end

return M
