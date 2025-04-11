local gtk = {}

local theme_map = {
  light = {
    gtk_theme = "blackbeard-light",
    icon_theme = "Adwaita",
    cursor_theme = "Adwaita",
  },
  dark = {
    gtk_theme = "blackbeard-dark",
    icon_theme = "Adwaita",
    cursor_theme = "Adwaita",
  },
}

local home = os.getenv("HOME")
local repo_base = vim.fn.stdpath("data") .. "/lazy/blackbeard-nvim/"
local themes_base = home .. "/.local/share/themes/" -- User-specific directory
local system_themes_base = "/usr/share/themes/" -- System-wide directory
local gtk2_config = home .. "/.gtkrc-2.0"
local gtk3_config = home .. "/.config/gtk-3.0/settings.ini"
local gtk4_config = home .. "/.config/gtk-4.0/settings.ini"

local function ensure_dir(path)
  local success = os.execute("mkdir -p " .. path)
  if not success then
    vim.notify("Failed to create directory: " .. path, vim.log.levels.ERROR)
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

local function copy_file_with_sudo(src, dest)
  if not file_exists(src) then
    vim.notify("Source file does not exist: " .. src, vim.log.levels.ERROR)
    return false
  end
  local cmd = "sudo cp " .. src .. " " .. dest
  local success = os.execute(cmd)
  if not success then
    vim.notify(
      "Failed to copy " .. src .. " to " .. dest .. ". You may need to provide your sudo password.",
      vim.log.levels.ERROR
    )
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
      vim.notify(theme_name .. " already installed in " .. themes_base, vim.log.levels.INFO)
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
      vim.notify("Installed " .. theme_name .. " to " .. themes_base, vim.log.levels.INFO)
    end
  end
end

function gtk.install_system_themes()
  for _, theme in pairs({ "dark", "light" }) do
    local settings = theme_map[theme]
    local theme_name = settings.gtk_theme
    local theme_dir = system_themes_base .. theme_name

    -- Skip if already installed
    if file_exists(theme_dir .. "/gtk-4.0/gtk.css") then
      vim.notify(theme_name .. " already installed in " .. system_themes_base, vim.log.levels.INFO)
    else
      local cmd = "sudo mkdir -p " .. theme_dir
      if not os.execute(cmd) then
        vim.notify(
          "Failed to create directory: " .. theme_dir .. ". You may need to provide your sudo password.",
          vim.log.levels.ERROR
        )
        return
      end
      cmd = "sudo mkdir -p " .. theme_dir .. "/gtk-2.0"
      if not os.execute(cmd) then
        return
      end
      cmd = "sudo mkdir -p " .. theme_dir .. "/gtk-3.0"
      if not os.execute(cmd) then
        return
      end
      cmd = "sudo mkdir -p " .. theme_dir .. "/gtk-4.0"
      if not os.execute(cmd) then
        return
      end

      local repo_theme_dir = repo_base .. theme_name
      local files_to_copy = {
        { src = repo_theme_dir .. "/gtk-2.0/gtkrc", dest = theme_dir .. "/gtk-2.0/gtkrc" },
        { src = repo_theme_dir .. "/gtk-3.0/gtk.css", dest = theme_dir .. "/gtk-3.0/gtk.css" },
        { src = repo_theme_dir .. "/gtk-4.0/gtk.css", dest = theme_dir .. "/gtk-4.0/gtk.css" },
      }

      for _, file in ipairs(files_to_copy) do
        if not copy_file_with_sudo(file.src, file.dest) then
          return
        end
      end
      vim.notify("Installed " .. theme_name .. " to " .. system_themes_base, vim.log.levels.INFO)
    end
  end
end

function gtk.update_theme(theme)
  if not theme_map[theme] then
    vim.notify("No GTK theme mapping for: " .. theme, vim.log.levels.ERROR)
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
  local gtk2_file, err = io.open(gtk2_config, "w")
  if gtk2_file then
    gtk2_file:write(gtk2_content)
    gtk2_file:close()
  else
    vim.notify("Failed to write GTK 2.0 config: " .. err, vim.log.levels.ERROR)
  end

  local gtk34_content = string.format(
    "[Settings]\n" .. "gtk-theme-name=%s\n" .. "gtk-icon-theme-name=%s\n" .. "gtk-cursor-theme-name=%s\n",
    theme_name,
    settings.icon_theme,
    settings.cursor_theme
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

  local gsettings_cmd = string.format("gsettings set org.gnome.desktop.interface gtk-theme '%s'", theme_name)
  local success = os.execute(gsettings_cmd)
  if not success then
    vim.notify("Failed to apply GTK theme via gsettings.", vim.log.levels.WARN)
  end

  vim.notify("GTK themes updated for " .. theme, vim.log.levels.INFO)
end

return gtk
