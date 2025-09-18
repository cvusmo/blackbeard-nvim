-- ~/blackbeard-nvim/lua/blackbeard/gimp.lua
local M = {}
local utils = require("blackbeard.utils")

local home = os.getenv("HOME")

function M.update_theme(theme)
  -- Ensure GIMP dir exists
  local gimp_dir = home .. "/.config/GIMP/3.0"
  vim.fn.mkdir(gimp_dir, "p") -- Create if missing

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
