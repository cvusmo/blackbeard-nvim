local M = {}
local alacritty = require("blackbeard.alacritty")
local dwm = require("blackbeard.dwm")
local gtk = require("blackbeard.gtk")

M.config = {
  theme = "dark",
  font_size = 24,
}

function M.get_current_theme()
  return M.config.theme
end

function M.setup(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
  if type(M.config.font_size) ~= "number" or M.config.font_size <= 0 then
    vim.notify("Invalid font_size in config; using default (24).", vim.log.levels.WARN)
    M.config.font_size = 24
  end

  vim.api.nvim_create_user_command("Blackbeard", function(opts)
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local action = args[1]
    local sub_action = args[2]
    if action == "light" or action == "dark" then
      if sub_action then
        vim.notify("Theme commands do not accept sub-actions.", vim.log.levels.ERROR)
        return
      end
      M.load(action)
      return
    end
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
    if action == "icon" then
      if not sub_action then
        vim.notify("Icon requires an icon theme name (e.g., Papirus-Dark).", vim.log.levels.ERROR)
        return
      end
      local icon_theme = sub_action
      -- Check if the icon theme exists in /usr/share/icons/
      if vim.fn.isdirectory("/usr/share/icons/" .. icon_theme) == 0 then
        vim.notify("Icon theme " .. icon_theme .. " not found in /usr/share/icons/", vim.log.levels.ERROR)
        return
      end
      -- Update GTK settings for icon theme
      local home = os.getenv("HOME")
      local gtk3_config = home .. "/.config/gtk-3.0/settings.ini"
      local gtk4_config = home .. "/.config/gtk-4.0/settings.ini"
      local gtk2_config = home .. "/.gtkrc-2.0"

      -- Update GTK 3 and 4 settings.ini
      local gtk34_content = string.format(
        "[Settings]\n" .. "gtk-theme-name=%s\n" .. "gtk-icon-theme-name=%s\n" .. "gtk-cursor-theme-name=Adwaita\n",
        M.config.theme == "dark" and "blackbeard-dark" or "blackbeard-light",
        icon_theme
      )

      vim.fn.mkdir(home .. "/.config/gtk-3.0", "p")
      local gtk3_file, err3 = io.open(gtk3_config, "w")
      if gtk3_file then
        gtk3_file:write(gtk34_content)
        gtk3_file:close()
      else
        vim.notify("Failed to write GTK 3.0 config: " .. err3, vim.log.levels.ERROR)
      end

      vim.fn.mkdir(home .. "/.config/gtk-4.0", "p")
      local gtk4_file, err4 = io.open(gtk4_config, "w")
      if gtk4_file then
        gtk4_file:write(gtk34_content)
        gtk4_file:close()
      else
        vim.notify("Failed to write GTK 4.0 config: " .. err4, vim.log.levels.ERROR)
      end

      -- Update GTK 2.0 gtkrc
      local gtk2_content = string.format(
        'gtk-theme-name="%s"\n' .. 'gtk-icon-theme-name="%s"\n' .. 'gtk-cursor-theme-name="Adwaita"\n',
        M.config.theme == "dark" and "blackbeard-dark" or "blackbeard-light",
        icon_theme
      )
      local gtk2_file, err2 = io.open(gtk2_config, "w")
      if gtk2_file then
        gtk2_file:write(gtk2_content)
        gtk2_file:close()
      else
        vim.notify("Failed to write GTK 2.0 config: " .. err2, vim.log.levels.ERROR)
      end

      -- Apply via gsettings
      local gsettings_cmd = string.format("gsettings set org.gnome.desktop.interface icon-theme '%s'", icon_theme)
      local success = os.execute(gsettings_cmd)
      if not success then
        vim.notify("Failed to apply icon theme via gsettings.", vim.log.levels.WARN)
      else
        vim.notify("Icon theme set to " .. icon_theme, vim.log.levels.INFO)
      end
      return
    end
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
    vim.notify("Invalid action: " .. (action or ""), vim.log.levels.ERROR)
  end, { nargs = "*", desc = "Blackbeard theme and update manager" })

  local ok, err = pcall(M.load, M.config.theme)
  if not ok then
    vim.notify("Failed to load initial theme: " .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.load(theme)
  theme = theme or M.config.theme
  M.config.theme = theme

  local ok, colors = pcall(require, "blackbeard." .. theme .. "-mode")
  if not ok or not colors then
    vim.notify("Blackbeard: Invalid theme specified: " .. theme .. " - " .. tostring(colors), vim.log.levels.ERROR)
    return
  end

  local theme_function = require("blackbeard.themes")[theme]
  if theme_function then
    local neovim_colors = theme_function(colors)
    M.apply_highlights(neovim_colors)
    local ok_alacritty, err_alacritty = pcall(alacritty.update_theme, theme, M.config.font_size)
    if not ok_alacritty then
      vim.notify("Failed to update Alacritty theme: " .. tostring(err_alacritty), vim.log.levels.ERROR)
    end
    local ok_gtk, err_gtk = pcall(gtk.update_theme, theme)
    if not ok_gtk then
      vim.notify("Failed to update GTK theme: " .. tostring(err_gtk), vim.log.levels.ERROR)
    end
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
