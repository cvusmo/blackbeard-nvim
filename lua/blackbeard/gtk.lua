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
local gtk2_config = home .. "/.gtkrc-2.0"
local gtk3_config = home .. "/.config/gtk-3.0/settings.ini"
local gtk4_config = home .. "/.config/gtk-4.0/settings.ini"

-- just a small helper
local function write_if_possible(path, content, label)
  if not utils.write_to_file(path, content) then
    utils.log("Failed to write " .. label, vim.log.levels.ERROR, false)
  end
end

function gtk.update_theme(theme)
  local settings = theme_map[theme]
  if not settings then
    utils.log("No GTK theme mapping for: " .. theme, vim.log.levels.ERROR, false)
    return
  end

  local theme_name = settings.gtk_theme

  -- avoid unnecessary work
  local stored_theme = utils.get_stored_theme()
  if stored_theme == theme then
    utils.log("Theme " .. theme .. " is already applied, skipping GTK update.", vim.log.levels.DEBUG, false)
    return
  end

  -- GTK 2.0
  local gtk2_content = string.format(
    'gtk-theme-name="%s"\n' .. 'gtk-icon-theme-name="%s"\n' .. 'gtk-cursor-theme-name="%s"\n',
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )
  write_if_possible(gtk2_config, gtk2_content, "GTK 2.0 config")

  -- GTK 3.0/4.0
  local gtk34_content = string.format(
    "[Settings]\n" .. "gtk-theme-name=%s\n" .. "gtk-icon-theme-name=%s\n" .. "gtk-cursor-theme-name=%s\n",
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )

  vim.fn.mkdir(home .. "/.config/gtk-3.0", "p")
  write_if_possible(gtk3_config, gtk34_content, "GTK 3.0 config")

  vim.fn.mkdir(home .. "/.config/gtk-4.0", "p")
  write_if_possible(gtk4_config, gtk34_content, "GTK 4.0 config")

  -- Apply theme via gsettings if available
  local gsettings_cmd =
    string.format("gsettings set org.gnome.desktop.interface gtk-theme '%s' >/dev/null 2>&1", theme_name)
  if os.execute(gsettings_cmd) ~= 0 then
    utils.log("Failed to apply GTK theme via gsettings.", vim.log.levels.WARN, false)
  end

  utils.store_theme(theme)
  utils.log("GTK themes switched to " .. theme, vim.log.levels.INFO, false)
end

return gtk
