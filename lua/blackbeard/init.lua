-- ~/blackbeard-nvim/lua/blackbeard/init.lua

local M = {}
local alacritty = require("blackbeard.alacritty")
local gtk = require("blackbeard.gtk")
local dmenu = require("blackbeard.dmenu") -- Add dmenu module
-- local waybar = require("blackbeard.waybar") -- Add Waybar module (commented out until ready)
-- local hyprland = require("blackbeard.hyprland") -- Commented out for now
local utils = require("blackbeard.utils")

M.config = {
  theme = "dark",
  font_size = 26,
}

function M.get_current_theme()
  return M.config.theme
end

function M.toggle_theme()
  local current_theme = M.get_current_theme()
  local new_theme = current_theme == "dark" and "light" or "dark"
  M.load(new_theme)
  utils.log("Toggled theme to " .. new_theme, vim.log.levels.INFO, true) -- User command
end

function M.setup(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
  if type(M.config.font_size) ~= "number" or M.config.font_size <= 0 then
    utils.log("Invalid font_size in config; using default (26).", vim.log.levels.WARN, false)
    M.config.font_size = 26
  end

  vim.api.nvim_create_user_command("Blackbeard", function(opts)
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local action = args[1]
    local sub_action = args[2]

    if action == "light" or action == "dark" then
      if sub_action then
        utils.log("Theme commands do not accept sub-actions.", vim.log.levels.ERROR, true)
        return
      end
      M.load(action)
      utils.log("Loaded " .. action .. " theme.", vim.log.levels.INFO, true)
      return
    end

    if action == "toggle" then
      if sub_action then
        utils.log("Toggle command does not accept sub-actions.", vim.log.levels.ERROR, true)
        return
      end
      M.toggle_theme()
      return
    end

    if action == "fontsize" then
      if not sub_action then
        utils.log("Fontsize requires a size (e.g., 16).", vim.log.levels.ERROR, true)
        return
      end
      local font_size = tonumber(sub_action)
      if not font_size or font_size <= 0 then
        utils.log("Invalid font size: " .. sub_action, vim.log.levels.ERROR, true)
        return
      end
      M.config.font_size = font_size
      alacritty.update_font_size(font_size)
      utils.log("Font size updated to " .. font_size, vim.log.levels.INFO, true)
      return
    end

    if action == "icon" then
      if not sub_action then
        utils.log("Icon requires an icon theme name (e.g., Papirus-Dark).", vim.log.levels.ERROR, true)
        return
      end
      local icon_theme = sub_action
      if vim.fn.isdirectory("/usr/share/icons/" .. icon_theme) == 0 then
        utils.log("Icon theme " .. icon_theme .. " not found in /usr/share/icons/", vim.log.levels.ERROR, true)
        return
      end
      utils.update_icon_theme(icon_theme, M.config.theme)
      utils.log("Icon theme set to " .. icon_theme, vim.log.levels.INFO, true)
      return
    end

    if action == "install-themes" then
      local source_dir = sub_action and vim.fn.expand(sub_action) or nil
      if source_dir and vim.fn.isdirectory(source_dir) == 0 then
        utils.log("Source directory " .. source_dir .. " does not exist.", vim.log.levels.ERROR, true)
        return
      end
      gtk.install_themes(source_dir)
      utils.log("User themes installed" .. (source_dir and " from " .. source_dir or ""), vim.log.levels.INFO, true)
      return
    end

    if action == "update" then
      if not sub_action then
        utils.log("Update requires a sub-action (e.g., hyprland, gtk).", vim.log.levels.ERROR, true)
        return
      end
      if sub_action == "hyprland" then
        local success = os.execute("hyprpm reload")
        if success then
          utils.log("Hyprland reloaded successfully.", vim.log.levels.INFO, true)
        else
          utils.log("Failed to reload Hyprland.", vim.log.levels.ERROR, true)
        end
      elseif sub_action == "gtk" then
        gtk.update_theme(M.config.theme)
        utils.log("GTK theme updated.", vim.log.levels.INFO, true)
      else
        utils.log("Invalid update sub-action: " .. sub_action, vim.log.levels.ERROR, true)
      end
      return
    end

    utils.log("Invalid action: " .. (action or ""), vim.log.levels.ERROR, true)
  end, { nargs = "*", desc = "Blackbeard theme and update manager" })

  -- Load the stored theme if it exists, otherwise use the default
  local stored_theme = utils.get_stored_theme()
  local initial_theme = stored_theme or M.config.theme
  local ok, err = pcall(M.load, initial_theme)
  if not ok then
    utils.log("Failed to load initial theme: " .. tostring(err), vim.log.levels.ERROR, false)
  end

  -- Reapply the Normal highlight group after plugins load to prevent overrides
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local theme = M.config.theme
      local colors = require("blackbeard." .. theme .. "-mode")
      local theme_function = require("blackbeard.themes")[theme]
      local neovim_colors = theme_function(colors)
      vim.api.nvim_set_hl(0, "Normal", { fg = neovim_colors.Normal.fg, bg = neovim_colors.Normal.bg })
    end,
  })
end

function M.load(theme)
  theme = theme or M.config.theme
  M.config.theme = theme

  -- Set vim.o.background to match the theme
  vim.o.background = theme == "dark" and "dark" or "light"

  local ok, colors = pcall(require, "blackbeard." .. theme .. "-mode")
  if not ok or not colors then
    utils.log(
      "Blackbeard: Invalid theme specified: " .. theme .. " - " .. tostring(colors),
      vim.log.levels.ERROR,
      false
    )
    return
  end

  local theme_function = require("blackbeard.themes")[theme]
  if theme_function then
    local neovim_colors = theme_function(colors)
    utils.apply_highlights(neovim_colors)
    -- Disable transparency to ensure the background is solid
    vim.o.winblend = 0
    vim.o.pumblend = 0
    -- Reapply the Normal highlight group to prevent overrides
    vim.api.nvim_set_hl(0, "Normal", { fg = neovim_colors.Normal.fg, bg = neovim_colors.Normal.bg })
    local ok_alacritty, err_alacritty = pcall(alacritty.update_theme, theme, M.config.font_size)
    if not ok_alacritty then
      utils.log("Failed to update Alacritty theme: " .. tostring(err_alacritty), vim.log.levels.ERROR, false)
    end
    local ok_gtk, err_gtk = pcall(gtk.update_theme, theme)
    if not ok_gtk then
      utils.log("Failed to update GTK theme: " .. tostring(err_gtk), vim.log.levels.ERROR, false)
    end
    local ok_dmenu, err_dmenu = pcall(dmenu.update_theme, theme)
    if not ok_dmenu then
      utils.log("Failed to update dmenu theme: " .. tostring(err_dmenu), vim.log.levels.ERROR, false)
    end
  else
    utils.log("Blackbeard: Theme function not found for " .. theme, vim.log.levels.ERROR, false)
  end

  -- Store the new theme
  utils.store_theme(theme)
end

return M
