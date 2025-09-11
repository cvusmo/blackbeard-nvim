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
local default_repo_base = vim.fn.stdpath("data") .. "/lazy/blackbeard-nvim/"
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

local function generate_gtk2_config(colors)
  return string.format(
    [[
# Global Style
style "default"
{
  bg[NORMAL]      = "%s"
  bg[PRELIGHT]    = "%s"
  bg[ACTIVE]      = "%s"
  bg[SELECTED]    = "%s"
  bg[INSENSITIVE] = "%s"

  fg[NORMAL]      = "%s"
  fg[PRELIGHT]    = "%s"
  fg[ACTIVE]      = "%s"
  fg[SELECTED]    = "%s"
  fg[INSENSITIVE] = "%s"

  base[NORMAL]    = "%s"
  base[PRELIGHT]  = "%s"
  base[ACTIVE]    = "%s"
  base[SELECTED]  = "%s"
  base[INSENSITIVE] = "%s"

  text[NORMAL]    = "%s"
  text[PRELIGHT]  = "%s"
  text[ACTIVE]    = "%s"
  text[SELECTED]  = "%s"
  text[INSENSITIVE] = "%s"
}
class "*" style "default"

# Window Background
style "window"
{
  bg[NORMAL] = "%s"
}
class "GtkWindow" style "window"

# Buttons
style "button"
{
  bg[NORMAL]   = "%s"
  bg[PRELIGHT] = "%s"
  bg[ACTIVE]   = "%s"
  fg[NORMAL]   = "%s"
  fg[PRELIGHT] = "%s"
  fg[ACTIVE]   = "%s"
}
class "GtkButton" style "button"

# Entries
style "entry"
{
  bg[NORMAL]   = "%s"
  fg[NORMAL]   = "%s"
  base[NORMAL] = "%s"
  text[NORMAL] = "%s"
}
class "GtkEntry" style "entry"

# Menu
style "menu"
{
  bg[NORMAL] = "%s"
  fg[NORMAL] = "%s"
}
class "GtkMenu" style "menu"

style "menuitem"
{
  bg[PRELIGHT] = "%s"
  fg[PRELIGHT] = "%s"
  bg[SELECTED] = "%s"
  fg[SELECTED] = "%s"
}
class "GtkMenuItem" style "menuitem"
]],
    colors.bg,
    colors.brwhite,
    colors.yellow,
    colors.selection_bg,
    colors.white, -- bg
    colors.fg,
    colors.fg,
    colors.fg,
    colors.selection_fg,
    colors.white, -- fg
    colors.bg,
    colors.brwhite,
    colors.selection_bg,
    colors.selection_bg,
    colors.black, -- base
    colors.fg,
    colors.fg,
    colors.selection_fg,
    colors.selection_fg,
    colors.white, -- text
    colors.bg, -- Window
    colors.white,
    colors.brwhite,
    colors.yellow,
    colors.fg,
    colors.fg,
    colors.fg, -- Button
    colors.bg,
    colors.fg,
    colors.bg,
    colors.fg, -- Entry
    colors.bg,
    colors.fg, -- Menu
    colors.brwhite,
    colors.fg,
    colors.selection_bg,
    colors.selection_fg -- MenuItem
  )
end

local function generate_gtk34_css(colors)
  return string.format(
    [[
/* Define Colors */
@define-color theme_bg            %s;
@define-color theme_fg            %s;
@define-color theme_cursor        %s;
@define-color theme_selection_bg  %s;
@define-color theme_selection_fg  %s;
@define-color theme_black         %s;
@define-color theme_red           %s;
@define-color theme_green         %s;
@define-color theme_yellow        %s;
@define-color theme_blue          %s;
@define-color theme_magenta       %s;
@define-color theme_cyan          %s;
@define-color theme_white         %s;
@define-color theme_brblack       %s;
@define-color theme_brred         %s;
@define-color theme_brgreen       %s;
@define-color theme_bryellow      %s;
@define-color theme_brblue        %s;
@define-color theme_brmagenta     %s;
@define-color theme_brcyan        %s;
@define-color theme_brwhite       %s;

/* Global Styles */
* {
    background-color: @theme_bg;
    color: @theme_fg;
    font-family: sans-serif;
}

/* Windows & Panels */
window, .background {
    background-color: @theme_bg;
    color: @theme_fg;
}

/* Headers (Titlebars) */
headerbar {
    background-color: @theme_black;
    color: @theme_fg;
    border-bottom: 1px solid @theme_brwhite;
}

/* Buttons */
button {
    background-image: none;
    background-color: @theme_white;
    border: 1px solid @theme_brwhite;
    color: @theme_fg;
    padding: 4px 8px;
    border-radius: 4px;
}
button:hover {
    background-color: @theme_brwhite;
    border: 1px solid @theme_white;
}
button:active {
    background-color: @theme_yellow;
    border: 1px solid @theme_brwhite;
}
button:focus {
    outline: none;
    border: 1px solid @theme_bryellow;
}

/* Entries and Text Areas */
entry, textview {
    background-color: @theme_bg;
    color: @theme_fg;
    border: 1px solid @theme_brwhite;
    padding: 2px 4px;
}
entry:focus, textview:focus {
    border-color: @theme_bryellow;
}

/* Cursor */
caret {
    background-color: @theme_cursor;
}

/* Selection */
selection, ::selection {
    background-color: @theme_selection_bg;
    color: @theme_selection_fg;
}

/* Scrollbars */
scrollbar {
    background-color: @theme_bg;
}
scrollbar slider {
    background-color: @theme_brblack;
    border-radius: 4px;
    min-width: 6px;
    min-height: 6px;
}
scrollbar slider:hover {
    background-color: @theme_brwhite;
}
scrollbar slider:active {
    background-color: @theme_yellow;
}

/* Menus */
menu, .menu, popover.menu {
    background-color: @theme_bg;
    color: @theme_fg;
    border: 1px solid @theme_brwhite;
}
menuitem, .menu .item {
    background-color: @theme_bg;
    color: @theme_fg;
    padding: 4px 8px;
}
menuitem:hover, .menu .item:hover {
    background-color: @theme_brwhite;
    color: @theme_fg;
}
menuitem:selected, .menu .item:selected {
    background-color: @theme_selection_bg;
    color: @theme_selection_fg;
}

/* Tooltips */
tooltip {
    background-color: @theme_black;
    color: @theme_fg;
    border: 1px solid @theme_brwhite;
    padding: 4px;
}

/* Lists and Treeviews */
treeview.view {
    background-color: @theme_bg;
    color: @theme_fg;
}
treeview.view:selected {
    background-color: @theme_selection_bg;
    color: @theme_selection_fg;
}
treeview.view:hover {
    background-color: @theme_brwhite;
    color: @theme_fg;
}

/* Tabs */
notebook > header {
    background-color: @theme_bg;
}
notebook > header tab {
    background-color: @theme_black;
    color: @theme_fg;
    padding: 4px 8px;
    border: 1px solid @theme_brwhite;
}
notebook > header tab:checked {
    background-color: @theme_bryellow;
}

/* Progress Bars */
progressbar trough {
    background-color: @theme_brblack;
    border-radius: 4px;
}
progressbar progress {
    background-color: @theme_green;
    border-radius: 4px;
}

/* Statusbar */
statusbar {
    background-color: @theme_black;
    color: @theme_fg;
    border-top: 1px solid @theme_brwhite;
    padding: 2px;
}

/* Toolbars */
toolbar {
    background-color: @theme_bg;
    color: @theme_fg;
    padding: 4px;
    border-bottom: 1px solid @theme_brwhite;
}
]],
    colors.bg,
    colors.fg,
    colors.cursor,
    colors.selection_bg,
    colors.selection_fg,
    colors.black,
    colors.red,
    colors.green,
    colors.yellow,
    colors.blue,
    colors.magenta,
    colors.cyan,
    colors.white,
    colors.brblack,
    colors.brred,
    colors.brgreen,
    colors.bryellow,
    colors.brblue,
    colors.brmagenta,
    colors.brcyan,
    colors.brwhite
  )
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
  local colors = require("blackbeard." .. theme .. "-mode")

  -- Generate GTK 2.0 config
  local gtk2_content = generate_gtk2_config(colors)
  if not utils.write_to_file(gtk2_config, gtk2_content) then
    utils.log("Failed to write GTK 2.0 config.", vim.log.levels.ERROR, false)
  end

  -- Generate GTK 3.0 and 4.0 CSS
  local gtk34_content = generate_gtk34_css(colors)
  vim.fn.mkdir(home .. "/.config/gtk-3.0", "p")
  if not utils.write_to_file(gtk3_config, gtk34_content) then
    utils.log("Failed to write GTK 3.0 config.", vim.log.levels.ERROR, false)
  end
  vim.fn.mkdir(home .. "/.config/gtk-4.0", "p")
  if not utils.write_to_file(gtk4_config, gtk34_content) then
    utils.log("Failed to write GTK 4.0 config.", vim.log.levels.ERROR, false)
  end

  -- Update gsettings
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
