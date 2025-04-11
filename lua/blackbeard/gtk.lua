local gtk = {}

-- Theme mapping
local theme_map = {
  light = {
    gtk_theme = "blackbeard-light",
    icon_theme = "Adwaita", -- Default, can be customized
    cursor_theme = "Adwaita", -- Default, can be customized
  },
  dark = {
    gtk_theme = "blackbeard-dark",
    icon_theme = "Adwaita",
    cursor_theme = "Adwaita",
  },
}

-- Paths
local home = os.getenv("HOME")
local repo_base = "/cvusmo/blackbeard-nvim/" -- Adjusted for your path
local themes_base = home .. "/.themes/"
local gtk2_config = home .. "/.gtkrc-2.0"
local gtk3_config = home .. "/.config/gtk-3.0/settings.ini"
local gtk4_config = home .. "/.config/gtk-4.0/settings.ini"

-- Ensure directory exists
local function ensure_dir(path)
  os.execute("mkdir -p " .. path)
end

-- Check if file exists
local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end
  return false
end

-- Copy file
local function copy_file(src, dest)
  if not file_exists(src) then
    vim.notify("Source file does not exist: " .. src, vim.log.levels.ERROR)
    return false
  end
  local success = os.execute("cp " .. src .. " " .. dest)
  if not success then
    vim.notify("Failed to copy " .. src .. " to " .. dest, vim.log.levels.ERROR)
    return false
  end
  return true
end

function gtk.update_theme(theme)
  if not theme_map[theme] then
    vim.notify("No GTK theme mapping for: " .. theme, vim.log.levels.ERROR)
    return
  end

  local settings = theme_map[theme]
  local theme_name = settings.gtk_theme
  local theme_dir = themes_base .. theme_name

  -- Create theme directory
  ensure_dir(theme_dir)
  ensure_dir(theme_dir .. "/gtk-2.0")
  ensure_dir(theme_dir .. "/gtk-3.0")
  ensure_dir(theme_dir .. "/gtk-4.0")

  -- Copy theme files from repo
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

  -- Update GTK 2.0 configuration
  local gtk2_content = string.format(
    'gtk-theme-name="%s"\n' .. 'gtk-icon-theme-name="%s"\n' .. 'gtk-cursor-theme-name="%s"\n',
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )
  local gtk2_file, err = io.open(gtk2_config, "w")
  if gtk2_file then
    gtk2_file:write(gtk2_content)
    gtk2_file:close()
  else
    vim.notify("Failed to write GTK 2.0 config: " .. err, vim.log.levels.ERROR)
  end

  -- Update GTK 3.0 and 4.0 configuration
  local gtk34_content = string.format(
    "[Settings]\n" .. "gtk-theme-name=%s\n" .. "gtk-icon-theme-name=%s\n" .. "gtk-cursor-theme-name=%s\n",
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
  )

  -- Write GTK 3.0 config
  ensure_dir(home .. "/.config/gtk-3.0")
  local gtk3_file, err3 = io.open(gtk3_config, "w")
  if gtk3_file then
    gtk3_file:write(gtk34_content)
    gtk3_file:close()
  else
    vim.notify("Failed to write GTK 3.0 config: " .. err3, vim.log.levels.ERROR)
  end

  -- Write GTK 4.0 config
  ensure_dir(home .. "/.config/gtk-4.0")
  local gtk4_file, err4 = io.open(gtk4_config, "w")
  if gtk4_file then
    gtk4_file:write(gtk34_content)
    gtk4_file:close()
  else
    vim.notify("Failed to write GTK 4.0 config: " .. err4, vim.log.levels.ERROR)
  end

  -- Apply theme immediately (for GNOME)
  local gsettings_cmd = string.format("gsettings set org.gnome.desktop.interface gtk-theme '%s'", theme_name)
  local success = os.execute(gsettings_cmd)
  if not success then
    vim.notify("Failed to apply GTK theme via gsettings.", vim.log.levels.WARN)
  end

  vim.notify("GTK themes updated for " .. theme, vim.log.levels.INFO)
end

return gtk
