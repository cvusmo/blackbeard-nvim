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
local default_repo_base = vim.fn.stdpath("data") .. "/lazy/blackbeard-nvim/"
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

function gtk.install_themes(source_dir)
  local repo_base = source_dir or default_repo_base

  for _, theme in pairs({ "dark", "light" }) do
    local settings = theme_map[theme]
    local theme_name = settings.gtk_theme
    local theme_dir = themes_base .. theme_name

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

  local stored_theme = utils.get_stored_theme()
  if stored_theme == theme then
    utils.log("Theme " .. theme .. " is already applied, skipping GTK update.", vim.log.levels.DEBUG, false)
    return
  end

  local settings = theme_map[theme]
  local theme_name = settings.gtk_theme

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

  -- GIMP Theme Override (Ensures clean Blackbeard application)
  local gimp_dir = home .. "/.config/GIMP/3.0"
  vim.fn.mkdir(gimp_dir, "p") -- Create dir if missing
  local gimp_css_path = gimp_dir .. "/gimp.css"
  local gimp_css_content
  if theme == "light" then
    gimp_css_content = [[
/* Blackbeard Light for GIMP - Gruvbox-inspired clean theme */
@import url("file:///home/echo/.local/share/themes/blackbeard-light/gtk-3.0/gtk.css");  /* Your custom GTK3 CSS */

/* GIMP-Specific Overrides for Clean Look */
* {
    -gtk-icon-style: symbolic;
    background-color: #F4E3C1;  /* theme_bg */
    color: #1C1B1A;             /* theme_fg */
    border: 1px solid #C9B999;  /* theme_brwhite for subtle borders */
    border-radius: 4px;
    outline: none;
}

/* Canvas & Layers (Keep transparent/clean) */
gimp-display {
    background-color: transparent;
    color: #1C1B1A;
}
gimp-layer-pane, gimp-channel-pane {
    background-color: #F4E3C1;
}

/* Toolbox & Dockables (Subtle lift, Gruvbox warm) */
gimp-toolbox, gimp-dock, gimp-dockbook {
    background-color: #6A5E47;  /* theme_white for softer bg */
    border: 1px solid #C9B999;
    color: #1C1B1A;
    padding: 4px;
}
gimp-toolbox button, gimp-dock button {
    background-color: #6A5E47;
    border: 1px solid #C9B999;
    color: #1C1B1A;
    border-radius: 4px;
    padding: 4px 6px;
}
gimp-toolbox button:hover, gimp-dock button:hover {
    background-color: #C9B999;  /* theme_brwhite hover lift */
    border-color: #C89F27;      /* theme_bryellow accent */
}
gimp-toolbox button:active, gimp-dock button:active {
    background-color: #A67F20;  /* theme_yellow active */
}

/* Menus & Dialogs (Match global menus) */
menu, menubar {
    background-color: #6A5E47;
    color: #1C1B1A;
    border: 1px solid #C9B999;
}
menuitem, menubar menuitem {
    background-color: transparent;
    color: #1C1B1A;
    padding: 6px 12px;
}
menuitem:hover, menubar menuitem:hover {
    background-color: #F4A259;  /* theme_selection_bg warm selection */
    color: #1C1B1A;
}

/* Entries & Labels (Clean input) */
entry, label {
    background-color: #F4E3C1;
    color: #1C1B1A;
    border: 1px solid #C9B999;
    padding: 4px;
}
entry:focus {
    border-color: #C89F27;  /* theme_bryellow focus */
    outline: none;
}

/* Scrollbars (Slim, matching global) */
scrollbar slider {
    background-color: #C9B999;
    border-radius: 4px;
    min-width: 6px;
}
scrollbar slider:hover {
    background-color: #C89F27;  /* theme_bryellow */
}

/* Progress & Scales (Green accents) */
progressbar progress {
    background-color: #4A7C2A;  /* theme_green */
    border-radius: 4px;
}
scale slider {
    background-color: #6A5E47;
    border: 1px solid #C9B999;
    border-radius: 50%;
}

/* Selection & Hovers (Warm orange) */
selection, ::selection {
    background-color: #F4A259;
    color: #1C1B1A;
}
row:hover {
    background-color: #C9B999;  /* Subtle row hover */
}

/* Tabs & Notebook (Underlined active) */
notebook tab {
    background-color: #6A5E47;
    color: #1C1B1A;
    border: 1px solid #C9B999;
    border-bottom: none;
    padding: 6px 10px;
}
notebook tab:checked {
    background-color: #F4E3C1;
    border-bottom: 1px solid #F4E3C1;
}
notebook tab:hover {
    background-color: #C9B999;
}

/* Disabled States (Muted) */
*:disabled {
    color: #6A5E47;  /* theme_white muted */
    background-color: #363533;  /* theme_brblack */
}

/* prefer-dark-theme (Fallback) */
@import url("file:///usr/share/gimp/3.0/themes/Default/gimp-light.css");  /* Fallback if needed */
    ]]
  else
    gimp_css_content = [[
/* Blackbeard Dark for GIMP - Gruvbox-inspired clean theme */
@import url("file:///home/echo/.local/share/themes/blackbeard-dark/gtk-3.0/gtk.css");  /* Your custom GTK3 CSS */

/* GIMP-Specific Overrides for Clean Look */
* {
    -gtk-icon-style: symbolic;
    background-color: #1C1B1A;  /* theme_bg */
    color: #F4E3C1;             /* theme_fg */
    border: 1px solid #F6E8CD;  /* theme_brwhite for subtle borders */
    border-radius: 4px;
    outline: none;
}

/* Canvas & Layers (Keep transparent/clean) */
gimp-display {
    background-color: transparent;
    color: #F4E3C1;
}
gimp-layer-pane, gimp-channel-pane {
    background-color: #1C1B1A;
}

/* Toolbox & Dockables (Subtle lift, Gruvbox warm) */
gimp-toolbox, gimp-dock, gimp-dockbook {
    background-color: #454240;  /* theme_black for softer bg */
    border: 1px solid #F6E8CD;
    color: #F4E3C1;
    padding: 4px;
}
gimp-toolbox button, gimp-dock button {
    background-color: #454240;
    border: 1px solid #F6E8CD;
    color: #F4E3C1;
    border-radius: 4px;
    padding: 4px 6px;
}
gimp-toolbox button:hover, gimp-dock button:hover {
    background-color: #AA9E87;  /* theme_white hover lift */
    border-color: #FADF60;      /* theme_bryellow accent */
}
gimp-toolbox button:active, gimp-dock button:active {
    background-color: #F1C232;  /* theme_yellow active */
}

/* Menus & Dialogs (Match global menus) */
menu, menubar {
    background-color: #454240;
    color: #F4E3C1;
    border: 1px solid #F6E8CD;
}
menuitem, menubar menuitem {
    background-color: transparent;
    color: #F4E3C1;
    padding: 6px 12px;
}
menuitem:hover, menubar menuitem:hover {
    background-color: #F4A259;  /* theme_selection_bg warm selection */
    color: #1C1B1A;
}

/* Entries & Labels (Clean input) */
entry, label {
    background-color: #1C1B1A;
    color: #F4E3C1;
    border: 1px solid #F6E8CD;
    padding: 4px;
}
entry:focus {
    border-color: #FADF60;  /* theme_bryellow focus */
    outline: none;
}

/* Scrollbars (Slim, matching global) */
scrollbar slider {
    background-color: #363533;  /* theme_brblack */
    border-radius: 4px;
    min-width: 6px;
}
scrollbar slider:hover {
    background-color: #F6E8CD;  /* theme_brwhite */
}

/* Progress & Scales (Green accents) */
progressbar progress {
    background-color: #73A857;  /* theme_green */
    border-radius: 4px;
}
scale slider {
    background-color: #454240;
    border: 1px solid #F6E8CD;
    border-radius: 50%;
}

/* Selection & Hovers (Warm orange) */
selection, ::selection {
    background-color: #F4A259;
    color: #1C1B1A;
}
row:hover {
    background-color: #AA9E87;  /* Subtle row hover */
}

/* Tabs & Notebook (Underlined active) */
notebook tab {
    background-color: #454240;
    color: #F4E3C1;
    border: 1px solid #F6E8CD;
    border-bottom: none;
    padding: 6px 10px;
}
notebook tab:checked {
    background-color: #1C1B1A;
    border-bottom: 1px solid #1C1B1A;
}
notebook tab:hover {
    background-color: #AA9E87;
}

/* Disabled States (Muted) */
*:disabled {
    color: #AA9E87;  /* theme_white muted */
    background-color: #363533;  /* theme_brblack */
}

/* prefer-dark-theme (Fallback) */
@import url("file:///usr/share/gimp/3.0/themes/Default/gimp-dark.css");  /* Fallback if needed */
    ]]
  end
  if not utils.write_to_file(gimp_css_path, gimp_css_content) then
    utils.log("Failed to write GIMP CSS to " .. gimp_css_path, vim.log.levels.ERROR, false)
  end

  utils.store_theme(theme)
  utils.log("GTK themes updated for " .. theme, vim.log.levels.INFO, false)
end

return gtk
