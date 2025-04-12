-- ~/blackbeard-nvim/lua/blackbeard/gtk.lua

local gtk = {}
local utils = require("blackbeard.utils") -- Ensure utils is required

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
local repo_base = vim.fn.stdpath("data") .. "/lazy/blackbeard-nvim/"
local themes_base = home .. "/.local/share/themes/" -- User-specific directory
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

local function copy_file(src, dest)
  if not file_exists(src) then
    utils.log("Source file does not exist: " .. src, vim.log.levels.ERROR, false)
    return false
  end
  local success = os.execute("cp " .. src .. " " .. dest)
  if not success then
    utils.log("Failed to copy " .. src .. " to " .. dest, vim.log.levels.ERROR, false)
    return false
  end
  return true
end

function gtk.install_themes()
  for _, theme in pairs({ "dark", "light" }) do
    local settings = theme_map[theme]
    local theme_name = settings.gtk_theme
    local theme_dir = themes_base .. theme_name

    -- Skip if already installed
    if file_exists(theme_dir .. "/gtk-4.0/gtk.css") then
      utils.log(theme_name .. " already installed in " .. themes_base, vim.log.levels.INFO, false)
    else
      if not ensure_dir(theme_dir) then
        return
      end
      if not ensure_dir(theme_dir .. "/gtk-2.0") then
        return
      end
      if not ensure_dir(theme_dir .. "/gtk-3.0") then
        return
      end
      if not ensure_dir(theme_dir .. "/gtk-4.0") then
        return
      end

      local repo_theme_dir = repo_base .. theme_name
      local files_to_copy = {
        { src = repo_theme_dir .. "/gtk-2.0/gtkrc", dest = theme_dir .. "/gtk-2.0/gtkrc" },
        { src = repo_theme_dir .. "/gtk-3.0/gtk.css", dest = theme_dir .. "/gtk-3.0/gtk.css" },
        { src = repo_theme_dir .. "/gtk-4.0/gtk.css", dest = theme_dir .. "/gtk-4.0/gtk.css" },
      }

      for _, file in ipairs(files_to_copy) do
        if not copy_file(file.src, file.dest) then
          return
        end
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

  -- Check if the theme has changed
  local stored_theme = utils.get_stored_theme()
  if stored_theme == theme then
    utils.log("Theme " .. theme .. " is already applied, skipping GTK update.", vim.log.levels.DEBUG, false)
    return
  end

  local settings = theme_map[theme]
  local theme_name = settings.gtk_theme

  -- Update user configuration files to use the theme
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

  -- Redirect gsettings output to suppress potential desktop environment notifications
  local gsettings_cmd =
    string.format("gsettings set org.gnome.desktop.interface gtk-theme '%s' >/dev/null 2>&1", theme_name)
  local success = os.execute(gsettings_cmd)
  if not success then
    utils.log("Failed to apply GTK theme via gsettings.", vim.log.levels.WARN, false)
  end

  -- Store the new theme
  utils.store_theme(theme)
  utils.log("GTK themes updated for " .. theme, vim.log.levels.INFO, false)
end

return gtk
