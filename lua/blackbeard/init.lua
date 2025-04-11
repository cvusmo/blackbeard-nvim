local M = {}
local alacritty = require("blackbeard.alacritty")
local dwm = require("blackbeard.dwm")
local gtk = require("blackbeard.gtk")

M.config = {
  theme = "dark", -- Default theme
  font_size = 24, -- Default Alacritty font size
}

function M.setup(config)
  -- Merge user-provided configuration with defaults
  M.config = vim.tbl_deep_extend("force", M.config, config or {})

  -- Validate font size
  if type(M.config.font_size) ~= "number" or M.config.font_size <= 0 then
    vim.notify("Invalid font_size in config; using default (24).", vim.log.levels.WARN)
    M.config.font_size = 24
  end

  -- Load the initial theme
  M.load(M.config.theme)

  -- Create a single user command to handle all Blackbeard actions
  vim.api.nvim_create_user_command("Blackbeard", function(opts)
    -- Split arguments
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local action = args[1]
    local sub_action = args[2]

    -- Handle theme changes (light, dark)
    if action == "light" or action == "dark" then
      if sub_action then
        vim.notify("Theme commands do not accept sub-actions.", vim.log.levels.ERROR)
        return
      end
      M.load(action)
      return
    end

    -- Handle font size change
    if action == "fontsize" then
      if not sub_action then
        vim.notify("Fontsize requires a size (e.g., 16).", vim.log.levels.ERROR)
        return
      end
      local font_size = tonumber(sub_action)
      if not font_size or font_size <= 0 then
        vim.notify("Invalid font size: " .. sub_action, vim.log.levels.ERROR)
        return
      end
      M.config.font_size = font_size
      alacritty.update_font_size(font_size)
      return
    end

    -- Handle update commands
    if action == "update" then
      if not sub_action then
        vim.notify("Update requires a sub-action (e.g., dwm, hyprland, gtk).", vim.log.levels.ERROR)
        return
      end
      if sub_action == "dwm" then
        dwm.update_theme(M.config.theme)
        vim.notify("DWM theme updated.", vim.log.levels.INFO)
      elseif sub_action == "hyprland" then
        local success = os.execute("hyprpm reload")
        if success then
          vim.notify("Hyprland reloaded successfully.", vim.log.levels.INFO)
        else
          vim.notify("Failed to reload Hyprland.", vim.log.levels.ERROR)
        end
      elseif sub_action == "gtk" then
        gtk.update_theme(M.config.theme)
      else
        vim.notify("Invalid update sub-action: " .. sub_action, vim.log.levels.ERROR)
      end
      return
    end

    -- Handle invalid actions
    vim.notify("Invalid action: " .. (action or ""), vim.log.levels.ERROR)
  end, { nargs = "*", desc = "Blackbeard theme and update manager" })
end

function M.load(theme)
  theme = theme or M.config.theme
  M.config.theme = theme

  -- Dynamically load colors based on the theme
  local ok, colors = pcall(require, "blackbeard." .. theme .. "-mode")
  if not ok or not colors then
    vim.notify("Blackbeard: Invalid theme specified: " .. theme, vim.log.levels.ERROR)
    return
  end

  -- Apply Neovim highlights for the selected theme
  local theme_function = require("blackbeard.themes")[theme]
  if theme_function then
    local neovim_colors = theme_function(colors)
    M.apply_highlights(neovim_colors)
    -- Update Alacritty with the current theme's colors and font size
    alacritty.update_theme(theme, M.config.font_size)
    -- Update GTK themes
    gtk.update_theme(theme)
  else
    vim.notify("Blackbeard: Theme function not found for " .. theme, vim.log.levels.ERROR)
  end
end

function M.apply_highlights(theme_colors)
  for group, settings in pairs(theme_colors) do
    local highlight_cmd = "highlight " .. group
    if settings.fg then
      highlight_cmd = highlight_cmd .. " guifg=" .. settings.fg
    end
    if settings.bg then
      highlight_cmd = highlight_cmd .. " guibg=" .. settings.bg
    end
    if settings.italic then
      highlight_cmd = highlight_cmd .. " gui=italic"
    end
    if settings.bold then
      highlight_cmd = highlight_cmd .. " gui=bold"
    end
    vim.cmd(highlight_cmd)
  end
end

return M
