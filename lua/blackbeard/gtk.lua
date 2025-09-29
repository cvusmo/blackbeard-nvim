-- ~/blackbeard-nvim/lua/blackbeard/gtk.lua
local gtk = {}
local utils = require("blackbeard.utils")

local theme_map = {
  light = {
    gtk_theme = "blackbeard-light",
    icon_theme = "Papirus-Light",
    cursor_theme = "Nordzy-cursors-light",
  },
  dark = {
    gtk_theme = "blackbeard-dark",
    icon_theme = "Papirus-Dark",
    cursor_theme = "Nordzy-cursors",
  },
}

local home = os.getenv("HOME")
local themes_base = home .. "/.local/share/themes/"
local gtk2_config = home .. "/.gtkrc-2.0"
local gtk3_config = home .. "/.config/gtk-3.0/settings.ini"
local gtk4_config = home .. "/.config/gtk-4.0/settings.ini"

local function ensure_dir(path)
  local success = os.execute("mkdir -p " .. path)
  if not success then
    utils.log("Failed to create directory: " .. path, vim.log.levels.ERROR, false)
    return false
  end
  return true
end

local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

function gtk.install_themes(source_dir)
  for _, theme in pairs({ "dark", "light" }) do
    local settings = theme_map[theme]
    local theme_name = settings.gtk_theme
    local theme_dir = themes_base .. theme_name
    local colors = require("blackbeard." .. theme .. "-mode")

    if file_exists(theme_dir .. "/gtk-4.0/gtk.css") then
      utils.log(theme_name .. " already installed in " .. themes_base, vim.log.levels.INFO, false)
    else
      if
        not ensure_dir(theme_dir .. "/gtk-2.0")
        or not ensure_dir(theme_dir .. "/gtk-3.0")
        or not ensure_dir(theme_dir .. "/gtk-4.0")
      then
        return
      end

      -- GTK 2.0 gtkrc
      local gtk2_content = string.format(
        [[gtk-theme-name = "%s"
gtk-icon-theme-name = "%s"
gtk-cursor-theme-name = "%s"
gtk-font-name = "Hurmit Nerd Font 12"
style "default"
{
  fg[NORMAL] = "%s"
  bg[NORMAL] = "%s"
  text[NORMAL] = "%s"
  base[NORMAL] = "%s"
  fg[SELECTED] = "%s"
  bg[SELECTED] = "%s"
}
class "*" style "default"]],
        theme_name,
        settings.icon_theme,
        settings.cursor_theme,
        colors.fg,
        colors.bg,
        colors.fg,
        colors.bg,
        colors.selection_fg,
        colors.selection_bg
      )
      if not utils.write_to_file(theme_dir .. "/gtk-2.0/gtkrc", gtk2_content) then
        utils.log("Failed to write GTK 2.0 theme for " .. theme_name, vim.log.levels.ERROR, false)
        return
      end

      -- GTK 3.0/4.0 CSS
      local gtk34_content = string.format(
        [[@define-color bg_color %s;
@define-color fg_color %s;
@define-color selected_bg_color %s;
@define-color selected_fg_color %s;
@define-color accent_color %s;

* {
  background-color: @bg_color;
  color: @fg_color;
  font-family: Hurmit Nerd Font, sans-serif;
  font-size: 12px;
}
window {
  background-color: @bg_color;
}
button, entry, textview text {
  background-color: @bg_color;
  color: @fg_color;
}
button:hover, button:active {
  background-color: @selected_bg_color;
  color: @selected_fg_color;
}
.selected, treeview selection {
  background-color: @selected_bg_color;
  color: @selected_fg_color;
}]],
        colors.bg,
        colors.fg,
        colors.selection_bg,
        colors.selection_fg,
        theme == "dark" and colors.green or colors.green
      )
      if not utils.write_to_file(theme_dir .. "/gtk-3.0/gtk.css", gtk34_content) then
        utils.log("Failed to write GTK 3.0 theme for " .. theme_name, vim.log.levels.ERROR, false)
        return
      end
      if not utils.write_to_file(theme_dir .. "/gtk-4.0/gtk.css", gtk34_content) then
        utils.log("Failed to write GTK 4.0 theme for " .. theme_name, vim.log.levels.ERROR, false)
        return
      end

      utils.log("Installed " .. theme_name .. " to " .. themes_base, vim.log.levels.INFO, false)
    end
  end
end

function gtk.update_theme(theme)
  if not theme_map[theme] then
    utils.log("No GTK theme mapping for: " .. theme, vim.log.levels.ERROR, false)
    return
  end

  local settings = theme_map[theme]
  local theme_name = settings.gtk_theme

  -- Validate icon and cursor themes
  if vim.fn.isdirectory("/usr/share/icons/" .. settings.icon_theme) == 0 then
    utils.log("Icon theme " .. settings.icon_theme .. " not found in /usr/share/icons/", vim.log.levels.ERROR, false)
    return
  end
  if vim.fn.isdirectory("/usr/share/icons/" .. settings.cursor_theme) == 0 then
    utils.log(
      "Cursor theme " .. settings.cursor_theme .. " not found in /usr/share/icons/",
      vim.log.levels.ERROR,
      false
    )
    return
  end

  local stored_theme = utils.get_stored_theme()
  if stored_theme == theme then
    utils.log("Theme " .. theme .. " is already applied, skipping GTK update.", vim.log.levels.DEBUG, false)
    return
  end

  local gtk2_content = string.format(
    'gtk-theme-name="%s"\n' .. 'gtk-icon-theme-name="%s"\n' .. 'gtk-cursor-theme-name="%s"\n',
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )
  if not utils.write_to_file(gtk2_config, gtk2_content) then
    utils.log("Failed to write GTK 2.0 config.", vim.log.levels.ERROR, false)
  end

  local gtk34_content = string.format(
    "[Settings]\n" .. "gtk-theme-name=%s\n" .. "gtk-icon-theme-name=%s\n" .. "gtk-cursor-theme-name=%s\n",
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )

  vim.fn.mkdir(home .. "/.config/gtk-3.0", "p")
  if not utils.write_to_file(gtk3_config, gtk34_content) then
    utils.log("Failed to write GTK 3.0 config.", vim.log.levels.ERROR, false)
  end

  vim.fn.mkdir(home .. "/.config/gtk-4.0", "p")
  if not utils.write_to_file(gtk4_config, gtk34_content) then
    utils.log("Failed to write GTK 4.0 config.", vim.log.levels.ERROR, false)
  end

  local gsettings_cmd =
    string.format("gsettings set org.gnome.desktop.interface gtk-theme '%s' >/dev/null 2>&1", theme_name)
  local success = os.execute(gsettings_cmd)
  if not success then
    utils.log("Failed to apply GTK theme via gsettings.", vim.log.levels.WARN, false)
  end

  -- Update GDM theme
  local gdm_cmd = string.format(
    "sudo -u gdm dbus-run-session gsettings set org.gnome.desktop.interface gtk-theme '%s' && "
      .. "sudo -u gdm dbus-run-session gsettings set org.gnome.desktop.interface icon-theme '%s' && "
      .. "sudo -u gdm dbus-run-session gsettings set org.gnome.desktop.interface cursor-theme '%s'",
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )
  if os.execute(gdm_cmd) then
    utils.log("Updated GDM theme to " .. theme_name, vim.log.levels.INFO, false)
  else
    utils.log("Failed to update GDM theme", vim.log.levels.ERROR, false)
  end

  -- Delegate GIMP theming to its module
  local ok, err = pcall(gimp.update_theme, theme)
  if not ok then
    utils.log("Failed to update GIMP theme: " .. tostring(err), vim.log.levels.WARN, false)
  end

  utils.store_theme(theme)
  utils.log("GTK themes updated for " .. theme, vim.log.levels.INFO, false)
end

return gtk
