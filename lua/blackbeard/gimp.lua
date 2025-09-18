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
/* Based on GIMP default theme.css, customized with Blackbeard palette */

@import url("file:///home/echo/.local/share/themes/blackbeard-light/gtk-3.0/gtk.css");  /* Your custom GTK3 CSS */

/* GIMP-Specific Variables (Mapped to Blackbeard Light) */
@define-color fg-color               #1C1B1A;  /* theme_fg: dark gray */
@define-color bg-color               #F4E3C1;  /* theme_bg: light beige */
@define-color border-color           #C9B999;  /* theme_brwhite: soft border */
@define-color dimmed-fg-color        #6A5E47;  /* theme_white: muted text */
@define-color disabled-fg-color      #363533;  /* theme_brblack: disabled */
@define-color disabled-button-color  #514A45;  /* theme_brblack variant */
@define-color hover-color            #C9B999;  /* theme_brwhite: hover lift */
@define-color widget-bg-color        #6A5E47;  /* theme_white: widget bg */
@define-color selected-color         #F4A259;  /* theme_selection_bg: warm orange */
@define-color extreme-bg-color       #F4E3C1;  /* theme_bg variant */
@define-color extreme-selected-color #A67F20;  /* theme_yellow: strong select */
@define-color strong-border-color    #C89F27;  /* theme_bryellow: accent border */
@define-color stronger-border-color  #A67F20;  /* theme_yellow: stronger */
@define-color edge-border-color      #C9B999;  /* theme_brwhite: edge */
@define-color scrollbar-slider-color #C9B999;  /* theme_brwhite: slider */
@define-color scrollbar-trough-color #F4E3C1;  /* theme_bg: trough */
@define-color ruler-color            rgba(242, 242, 242, 0.3);  /* Light ruler grid */
@define-color sap                    #C9B999;  /* theme_brwhite: separator */

/* Global GIMP Styles (From provided CSS, customized) */
* {
    -gtk-icon-style:                   symbolic;
    -GimpDockWindow-default-height:    300;
    -GimpMenuDock-minimal-width:       200;
    -GimpDockWindow-menu-preview-size: button;
    -GimpToolPalette-tool-icon-size:   small-toolbar;
    -GimpToolPalette-button-relief:    none;
    -GimpDock-tool-icon-size:          small-toolbar;
    -GimpDockbook-tab-icon-size:       button;
    -GimpColorNotebook-tab-icon-size:  button;
    -GimpDockable-content-border:      1;
    -GimpEditor-content-spacing:       1;
    -GimpEditor-button-spacing:        1;
    -GimpEditor-button-icon-size:      menu;
    -GimpDataEditor-minimal-height:    96;
    -GtkDialog-content-area-border:    0;
    -GtkDialog-button-spacing:         1;
    -GtkDialog-action-area-border:     8;
    -GimpUnitComboBox-appears-as-list: 0;
    color: @fg-color;
    background-color: @bg-color;
    border: 1px solid @border-color;
    border-radius: 4px;
    outline: none;
}

*:disabled {
    color: @disabled-fg-color;
    background-color: @widget-bg-color;
}

/* Windows & Panels */
window, .background, dialog {
    background-color: @bg-color;
    color: @fg-color;
}

/* Headerbars */
headerbar {
    background-color: @widget-bg-color;
    color: @fg-color;
    border-bottom: 1px solid @stronger-border-color;
    padding: 4px;
    min-height: 36px;
}
headerbar:backdrop * {
    color: @disabled-fg-color;
}
headerbar button.titlebutton {
    box-shadow: none;
}

/* Buttons (Compact, rounded for tools/dialogs) */
button {
    background-color: @widget-bg-color;
    border: 1px solid @strong-border-color;
    color: @fg-color;
    padding: 4px 8px;
    border-radius: 4px;
    background-image: none;
}
button:hover {
    background-color: @hover-color;
    border-color: @stronger-border-color;
}
button:active, button:checked {
    background-color: @selected-color;
    border-color: @edge-border-color;
}
button:focus {
    outline: none;
    border-color: @stronger-border-color;
    box-shadow: 0 0 0 1px @hover-color;
}
button.default {
    border: 1px solid @stronger-border-color;
}
button.suggested-action {
    border: 1px solid @stronger-border-color;
    background-color: @hover-color;
}
button.destructive-action {
    border: 1px dashed @stronger-border-color;
}
button:disabled {
    color: @disabled-button-color;
    background-color: @extreme-bg-color;
}

/* Thunar/GIMP File Dialog Buttons */
.thunar .standard-view .button, GimpToolDialog button, GimpOverlayDialog button {
    padding: 0 2px;
    background-color: @widget-bg-color;
}
.thunar .standard-view .button:hover, GimpToolDialog button:hover {
    background-color: @hover-color;
}

/* Entries/Spinbuttons (Compact input) */
entry, textview, spinbutton, .entry, .textview {
    background-color: @extreme-bg-color;
    color: @fg-color;
    border: 1px solid @strong-border-color;
    padding: 2px 4px;
    border-radius: 3px;
}
entry:focus, textview:focus, spinbutton:focus {
    border-color: @stronger-border-color;
    outline: none;
    box-shadow: 0 0 0 1px @hover-color;
}
entry selection, textview selection {
    background-color: @fg-color;
    color: @bg-color;
}
entry:disabled {
    background-color: @extreme-bg-color;
    color: @disabled-fg-color;
}

/* GimpSpinScale (Custom scales) */
GimpSpinScale entry {
    min-height: 16px;
    padding: 0 0.5em;
    border-top-right-radius: 4px;
    border-bottom-right-radius: 4px;
}
GimpSpinScale entry progress {
    background-color: @selected-color;
    border-radius: 3px;
    margin: 0 -8px 0 -5px;
}
GimpSpinScale button {
    padding: 0 1px;
    border-radius: 4px;
    border: 1px solid @border-color;
}
GimpSpinScale button.up {
    border-top-right-radius: 4px;
    border-bottom-right-radius: 4px;
}

/* Check/Radio Buttons */
checkbutton, radiobutton, checkbutton label {
    color: @fg-color;
    background-color: @bg-color;
}
checkbutton:hover, radiobutton:hover {
    background-color: @hover-color;
}
checkbutton check, radiobutton radio {
    background-color: @extreme-bg-color;
    border: 1px solid @stronger-border-color;
    color: @fg-color;
    border-radius: 3px;
}
checkbutton check:checked, radiobutton radio:checked {
    background-color: @selected-color;
}
checkbutton check:disabled {
    background-color: @bg-color;
    color: @disabled-fg-color;
}
checkbutton:checked label {
    font-weight: bold;
}

/* Menus (Top bar & dropdowns) */
menubar, menu {
    background-color: @widget-bg-color;
    color: @fg-color;
    border: 1px solid @strong-border-color;
}
menubar > menuitem:hover {
    background-color: @extreme-bg-color;
}
menuitem, menubar menuitem {
    background-color: @bg-color;
    color: @fg-color;
    padding: 4px 8px;
}
menuitem:hover, menubar menuitem:hover {
    background-color: @extreme-selected-color;
    color: @fg-color;
}
menuitem:selected {
    background-color: @selected-color;
}
menu separator {
    background-color: @stronger-border-color;
    margin: 0;
}
paned menu separator {
    padding: 0;
}

/* Tooltips (Compact, bordered) */
tooltip {
    background-color: @widget-bg-color;
    color: @fg-color;
    border: 1px solid @edge-border-color;
    border-radius: 4px;
    padding: 4px;
    box-shadow: 0 1px 2px @border-color;
}
tooltip decoration {
    box-shadow: 0 0;
}
tooltip box {
    background-color: @widget-bg-color;
    border: 0;
}

/* Lists/Treeviews (File dialogs, layers) */
treeview, list, .view {
    background-color: @extreme-bg-color;
    color: @fg-color;
    border: 1px solid @strong-border-color;
}
treeview:selected, list:selected, .view:selected {
    background-color: @extreme-selected-color;
    color: @fg-color;
}
treeview row:hover, list row:hover, .view row:hover {
    background-color: @hover-color;
}
treeview header button {
    background-color: @bg-color;
    border: 1px solid @stronger-border-color;
    padding: 6px;
}
treeview .toggle-icon:not(.visible):hover {
    border: 1px solid @fg-color;
    border-radius: 3px;
}
treeview .toggle-icon:not(.visible):selected {
    border-color: @dimmed-fg-color;
}

/* Thunar/GIMP File List */
.thunar .standard-view .view, GimpFileDialog treeview {
    background-color: @extreme-bg-color;
}
.thunar .standard-view row:selected, GimpFileDialog row:selected {
    background-color: @extreme-selected-color;
}
.thunar .standard-view row:hover, GimpFileDialog row:hover {
    background-color: @hover-color;
}

/* Tabs/Notebook (Dock tabs, image tabs) */
notebook > header, notebook header {
    background-color: @bg-color;
    border-bottom: 1px solid @stronger-border-color;
    padding: 4px;
}
notebook > header tab, notebook header tab {
    background-color: @widget-bg-color;
    color: @fg-color;
    padding: 6px 10px;
    border: 1px solid @strong-border-color;
    border-bottom: none;
    border-radius: 4px 4px 0 0;
    margin-right: 2px;
}
notebook > header tab:checked, notebook header tab:checked {
    background-color: @extreme-bg-color;
    border-bottom: 1px solid @extreme-bg-color;
}
notebook > header tab:hover, notebook header tab:hover {
    background-color: @hover-color;
}
notebook > header tab > box > button {
    margin-right: 5px;
}
GimpColorNotebook tab {
    padding: 0;
    min-width: 30px;
    min-height: 30px;
}

/* Progress Bars (Green fill, subtle trough) */
progressbar {
    min-height: 8px;
    border-radius: 4px;
    background-color: transparent;
}
progressbar trough {
    background-color: @stronger-border-color;
    border-radius: 4px;
}
progressbar progress {
    background-color: @theme_green;  /* #4A7C2A light green */
    border-radius: 4px;
}

/* Scrollbars (Slim, colored) */
scrollbar {
    background-color: @bg-color;
    border-color: @border-color;
}
scrollbar trough {
    background-color: @scrollbar-trough-color;
    border-radius: 4px;
}
scrollbar slider {
    background-color: @scrollbar-slider-color;
    border: 2px solid @border-color;
    border-radius: 6px;
    min-width: 6px;
    min-height: 6px;
    margin: 2px;
}
scrollbar slider:hover {
    background-color: @stronger-border-color;
}
scrollbar slider:active {
    background-color: @selected-color;
}
scrollbar.fine-tune slider {
    min-width: 4px;
    min-height: 4px;
}

/* Separators (Thin lines) */
separator {
    background-color: @sap;
    min-width: 1px;
    min-height: 1px;
    margin: -0.1em;
}
separator.wide {
    background-color: @sap;
    background-size: 1px 1px;
    box-shadow: none;
    border: 0;
}
separator.wide:hover {
    background-color: @sap;
    box-shadow: none;
    border: 0;
}
paned separator {
    color: @border-color;
    background-color: @border-color;
    background-position: center;
    padding: 1px;
}
menu separator {
    background-color: @sap;
    margin: 0;
}

/* Frames & Borders (Subtle) */
frame {
    border: 1px solid @strong-border-color;
    border-radius: 4px;
    padding: 2px;
}
frame border {
    background-image: none;
    border: 0;
}
.gimp-offset-area-frame {
    border: 2px solid @stronger-border-color;
    background-color: @widget-bg-color;
}

/* Switches & Scales (Gruvbox accents) */
switch {
    background-color: @widget-bg-color;
    border: 1px solid @strong-border-color;
    border-radius: 20px;
    min-height: 20px;
}
switch:checked {
    background-color: @theme_green;  /* #4A7C2A light green */
}
scale slider {
    background-color: @widget-bg-color;
    border: 1px solid @strong-border-color;
    border-radius: 50%;
}
scale trough {
    background-color: @stronger-border-color;
    border-radius: 4px;
}

/* Dialogs & Action Bars */
GtkDialog {
    border: 1px solid @border-color;
}
.actionbar, .dialog-action-box {
    background-color: @widget-bg-color;
    border-top: 1px solid @stronger-border-color;
    padding: 4px;
}
.actionbar revealer box {
    border-top: 1px solid @strong-border-color;
}

/* Rulers & Canvas (Transparent grid) */
GimpRuler {
    background-color: @ruler-color;
}
#gimp-canvas {
    color: @dimmed-fg-color;
}
GimpDisplayShell grid > button {
    min-height: 0;
    min-width: 0;
    padding: 0;
    background-color: transparent;
}
GimpDisplayShell progressbar trough, GimpDisplayShell progressbar progress {
    min-height: 1em;
}
GimpFileDialog progressbar trough, GimpFileDialog progressbar progress {
    min-width: 1px;
    min-height: 1em;
}

/* Path Bar (File dialogs) */
#pathbarbox button:hover {
    background-color: @hover-color;
}

/* Image Menu Bar */
#image-menubar, GtkImageMenuItem {
    background-color: @bg-color;
    color: @fg-color;
}

/* Combobox Dropdowns */
combobox window.popup, combobox window {
    background-color: @widget-bg-color;
    color: @fg-color;
}
combobox box, combobox box.linked, combobox button {
    background-color: transparent;
    border-color: @stronger-border-color;
    color: @fg-color;
}
combobox arrow {
    -gtk-icon-shadow: none;
}

/* ListBox Rows */
list, list row {
    background-color: @widget-bg-color;
}
list row:selected {
    background-color: @selected-color;
}
list row:hover {
    background-color: @hover-color;
}

/* TextView (e.g., layer names) */
textview text, textview {
    background-color: @extreme-bg-color;
    color: @fg-color;
}
textview text selection {
    background-color: @fg-color;
    color: @bg-color;
}

/* Checkboxes/Radios (Flat, rounded) */
checkbutton check, radiobutton radio, treeview.view check {
    background-color: @extreme-bg-color;
    border: 1px solid @stronger-border-color;
    border-radius: 3px;
}
checkbutton check:checked, radiobutton radio:checked {
    background-color: @selected-color;
    color: @fg-color;
}
checkbutton check:disabled, radiobutton radio:disabled {
    background-color: @bg-color;
    color: @disabled-fg-color;
}

/* Tool Dialogs & Overlay */
GimpToolDialog {
    -GtkDialog-action-area-border: 1px;
}
GimpOverlayDialog button {
    padding: 0 2px;
}

/* Color Selection (gimpcolordialog) */
GimpColorSelection ColorselCmyk {
    padding: 2px;
}
GimpColorHistory button {
    padding: 3px;
}
#gimp-color-tag-box button {
    padding: 4px 6px;
}
tab GimpFgBgView {
    padding: 6px;
}
GimpFgBgEditor:active {
    border-width: 1px;
}
GimpColorNotebook .frame {
    border-color: @bg-color;
}

/* About Dialog Credits */
.gimp-about-dialog box box stack scrolledwindow viewport grid {
    background-color: @extreme-bg-color;
}

/* Sidebar (File open) */
.sidebar-row, .sidebar-row * {
    background-color: @widget-bg-color;
}
.sidebar-row:selected, .sidebar-row:selected * {
    background-color: @selected-color;
}
.sidebar-row:hover, .sidebar-row:hover * {
    background-color: @hover-color;
}

/* Paned Separators */
paned separator {
    color: @border-color;
    background-color: @border-color;
    background-position: center;
    background-repeat: no-repeat;
    background-size: auto;
    padding: 1px;
}

/* Image Buttons (No blur) */
.image-button image, button image {
    -gtk-icon-shadow: 0 0 transparent;
}

/* Wilber Icon (Toolbox) */
GimpDock frame:first-child:not(label) {
    color: @dimmed-fg-color;
}
GimpDock frame:first-child label {
    color: @fg-color;
}

/* Offset Area Frame */
.gimp-offset-area-frame {
    border: solid 2px @stronger-border-color;
    background-color: @widget-bg-color;
}

/* Sample Point Editor */
GimpSamplePointEditor box.vertical {
    background-color: transparent;
}

/* Unit ComboBox */
GimpUnitComboBox {
    -GtkComboBox-appears-as-list: 0;
}
]]
  else
    gimp_css_content = [[
    /* Blackbeard Dark for GIMP - Gruvbox-inspired clean theme */
@import url("file:///home/echo/.local/share/themes/blackbeard-dark/gtk-3.0/gtk.css");  /* Your custom GTK3 CSS */

/* GIMP-Specific Variables (Mapped to Blackbeard Dark) */
@define-color fg-color               #F4E3C1;  /* theme_fg: warm beige */
@define-color bg-color               #1C1B1A;  /* theme_bg: deep gray */
@define-color border-color           #F6E8CD;  /* theme_brwhite: soft border */
@define-color dimmed-fg-color        #AA9E87;  /* theme_white: muted text */
@define-color disabled-fg-color      #363533;  /* theme_brblack: disabled */
@define-color disabled-button-color  #454240;  /* theme_black variant */
@define-color hover-color            #AA9E87;  /* theme_white: hover lift */
@define-color widget-bg-color        #454240;  /* theme_black: widget bg */
@define-color selected-color         #F4A259;  /* theme_selection_bg: warm orange */
@define-color extreme-bg-color       #1C1B1A;  /* theme_bg variant */
@define-color extreme-selected-color #F1C232;  /* theme_yellow: strong select */
@define-color strong-border-color    #FADF60;  /* theme_bryellow: accent border */
@define-color stronger-border-color  #F1C232;  /* theme_yellow: stronger */
@define-color edge-border-color      #F6E8CD;  /* theme_brwhite: edge */
@define-color scrollbar-slider-color #F6E8CD;  /* theme_brwhite: slider */
@define-color scrollbar-trough-color #1C1B1A;  /* theme_bg: trough */
@define-color ruler-color            rgba(40,40,40,0.3);  /* Dark ruler grid */
@define-color sap                    #F6E8CD;  /* theme_brwhite: separator */

/* Global GIMP Styles (From provided CSS, customized) */
* {
    -gtk-icon-style:                   symbolic;
    -GimpDockWindow-default-height:    300;
    -GimpMenuDock-minimal-width:       200;
    -GimpDockWindow-menu-preview-size: button;
    -GimpToolPalette-tool-icon-size:   small-toolbar;
    -GimpToolPalette-button-relief:    none;
    -GimpDock-tool-icon-size:          small-toolbar;
    -GimpDockbook-tab-icon-size:       button;
    -GimpColorNotebook-tab-icon-size:  button;
    -GimpDockable-content-border:      1;
    -GimpEditor-content-spacing:       1;
    -GimpEditor-button-spacing:        1;
    -GimpEditor-button-icon-size:      menu;
    -GimpDataEditor-minimal-height:    96;
    -GtkDialog-content-area-border:    0;
    -GtkDialog-button-spacing:         1;
    -GtkDialog-action-area-border:     8;
    -GimpUnitComboBox-appears-as-list: 0;
    color: @fg-color;
    background-color: @bg-color;
    border: 1px solid @border-color;
    border-radius: 4px;
    outline: none;
}

*:disabled {
    color: @disabled-fg-color;
    background-color: @widget-bg-color;
}

/* Windows & Panels */
window, .background, dialog {
    background-color: @bg-color;
    color: @fg-color;
}

/* Headerbars */
headerbar {
    background-color: @widget-bg-color;
    color: @fg-color;
    border-bottom: 1px solid @stronger-border-color;
    padding: 4px;
    min-height: 36px;
}
headerbar:backdrop * {
    color: @disabled-fg-color;
}
headerbar button.titlebutton {
    box-shadow: none;
}

/* Buttons (Compact, rounded for tools/dialogs) */
button {
    background-color: @widget-bg-color;
    border: 1px solid @strong-border-color;
    color: @fg-color;
    padding: 4px 8px;
    border-radius: 4px;
    background-image: none;
}
button:hover {
    background-color: @hover-color;
    border-color: @stronger-border-color;
}
button:active, button:checked {
    background-color: @selected-color;
    border-color: @edge-border-color;
}
button:focus {
    outline: none;
    border-color: @stronger-border-color;
    box-shadow: 0 0 0 1px @hover-color;
}
button.default {
    border: 1px solid @stronger-border-color;
}
button.suggested-action {
    border: 1px solid @stronger-border-color;
    background-color: @hover-color;
}
button.destructive-action {
    border: 1px dashed @stronger-border-color;
}
button:disabled {
    color: @disabled-button-color;
    background-color: @extreme-bg-color;
}

/* Thunar/GIMP File Dialog Buttons */
.thunar .standard-view .button, GimpToolDialog button, GimpOverlayDialog button {
    padding: 0 2px;
    background-color: @widget-bg-color;
}
.thunar .standard-view .button:hover, GimpToolDialog button:hover {
    background-color: @hover-color;
}

/* Entries/Spinbuttons (Compact input) */
entry, textview, spinbutton, .entry, .textview {
    background-color: @extreme-bg-color;
    color: @fg-color;
    border: 1px solid @strong-border-color;
    padding: 2px 4px;
    border-radius: 3px;
}
entry:focus, textview:focus, spinbutton:focus {
    border-color: @stronger-border-color;
    outline: none;
    box-shadow: 0 0 0 1px @hover-color;
}
entry selection, textview selection {
    background-color: @fg-color;
    color: @bg-color;
}
entry:disabled {
    background-color: @extreme-bg-color;
    color: @disabled-fg-color;
}

/* GimpSpinScale (Custom scales) */
GimpSpinScale entry {
    min-height: 16px;
    padding: 0 0.5em;
    border-top-right-radius: 4px;
    border-bottom-right-radius: 4px;
}
GimpSpinScale entry progress {
    background-color: @selected-color;
    border-radius: 3px;
    margin: 0 -8px 0 -5px;
}
GimpSpinScale button {
    padding: 0 1px;
    border-radius: 4px;
    border: 1px solid @border-color;
}
GimpSpinScale button.up {
    border-top-right-radius: 4px;
    border-bottom-right-radius: 4px;
}

/* Check/Radio Buttons */
checkbutton, radiobutton, checkbutton label {
    color: @fg-color;
    background-color: @bg-color;
}
checkbutton:hover, radiobutton:hover {
    background-color: @hover-color;
}
checkbutton check, radiobutton radio {
    background-color: @extreme-bg-color;
    border: 1px solid @stronger-border-color;
    border-radius: 3px;
    color: @fg-color;
}
checkbutton check:checked, radiobutton radio:checked {
    background-color: @selected-color;
}
checkbutton check:disabled, radiobutton radio:disabled {
    background-color: @bg-color;
    color: @disabled-fg-color;
}
checkbutton:checked label {
    font-weight: bold;
}

/* Menus (Top bar & dropdowns) */
menubar, menu {
    background-color: @widget-bg-color;
    color: @fg-color;
    border: 1px solid @strong-border-color;
}
menubar > menuitem:hover {
    background-color: @extreme-bg-color;
}
menuitem, menubar menuitem {
    background-color: @bg-color;
    color: @fg-color;
    padding: 4px 8px;
}
menuitem:hover, menubar menuitem:hover {
    background-color: @extreme-selected-color;
    color: @fg-color;
}
menuitem:selected {
    background-color: @selected-color;
}
menu separator {
    background-color: @stronger-border-color;
    margin: 0;
}
paned menu separator {
    padding: 0;
}

/* Tooltips (Compact, bordered) */
tooltip {
    background-color: @widget-bg-color;
    color: @fg-color;
    border: 1px solid @edge-border-color;
    border-radius: 4px;
    padding: 4px;
    box-shadow: 0 1px 2px @border-color;
}
tooltip decoration {
    box-shadow: 0 0;
}
tooltip box {
    background-color: @widget-bg-color;
    border: 0;
}

/* Lists/Treeviews (File dialogs, layers) */
treeview, list, .view {
    background-color: @extreme-bg-color;
    color: @fg-color;
    border: 1px solid @strong-border-color;
}
treeview:selected, list:selected, .view:selected {
    background-color: @extreme-selected-color;
    color: @fg-color;
}
treeview row:hover, list row:hover, .view row:hover {
    background-color: @hover-color;
}
treeview header button {
    background-color: @bg-color;
    border: 1px solid @stronger-border-color;
    padding: 6px;
}
treeview .toggle-icon:not(.visible):hover {
    border: 1px solid @fg-color;
    border-radius: 3px;
}
treeview .toggle-icon:not(.visible):selected {
    border-color: @dimmed-fg-color;
}

/* Thunar/GIMP File List */
.thunar .standard-view .view, GimpFileDialog treeview {
    background-color: @extreme-bg-color;
}
.thunar .standard-view row:selected, GimpFileDialog row:selected {
    background-color: @extreme-selected-color;
}
.thunar .standard-view row:hover, GimpFileDialog row:hover {
    background-color: @hover-color;
}

/* Tabs/Notebook (Dock tabs, image tabs) */
notebook > header, notebook header {
    background-color: @bg-color;
    border-bottom: 1px solid @stronger-border-color;
    padding: 4px;
}
notebook > header tab, notebook header tab {
    background-color: @widget-bg-color;
    color: @fg-color;
    padding: 6px 10px;
    border: 1px solid @strong-border-color;
    border-bottom: none;
    border-radius: 4px 4px 0 0;
    margin-right: 2px;
}
notebook > header tab:checked, notebook header tab:checked {
    background-color: @extreme-bg-color;
    border-bottom: 1px solid @extreme-bg-color;
}
notebook > header tab:hover, notebook header tab:hover {
    background-color: @hover-color;
}
notebook > header tab > box > button {
    margin-right: 5px;
}
GimpColorNotebook tab {
    padding: 0;
    min-width: 30px;
    min-height: 30px;
}

/* Progress Bars (Green fill, subtle trough) */
progressbar {
    min-height: 8px;
    border-radius: 4px;
    background-color: transparent;
}
progressbar trough {
    background-color: @stronger-border-color;
    border-radius: 4px;
}
progressbar progress {
    background-color: @theme_green;  /* #73A857 dark green */
    border-radius: 4px;
}

/* Scrollbars (Slim, colored) */
scrollbar {
    background-color: @bg-color;
    border-color: @border-color;
}
scrollbar trough {
    background-color: @scrollbar-trough-color;
    border-radius: 4px;
}
scrollbar slider {
    background-color: @scrollbar-slider-color;
    border: 2px solid @border-color;
    border-radius: 6px;
    min-width: 6px;
    min-height: 6px;
    margin: 2px;
}
scrollbar slider:hover {
    background-color: @stronger-border-color;
}
scrollbar slider:active {
    background-color: @selected-color;
}
scrollbar.fine-tune slider {
    min-width: 4px;
    min-height: 4px;
}

/* Separators (Thin lines) */
separator {
    background-color: @sap;
    min-width: 1px;
    min-height: 1px;
    margin: -0.1em;
}
separator.wide {
    background-color: @sap;
    background-size: 1px 1px;
    box-shadow: none;
    border: 0;
}
separator.wide:hover {
    background-color: @sap;
    box-shadow: none;
    border: 0;
}
paned separator {
    color: @border-color;
    background-color: @border-color;
    background-position: center;
    background-repeat: no-repeat;
    background-size: auto;
    padding: 1px;
}
menu separator {
    background-color: @sap;
    margin: 0;
}

/* Frames & Borders (Subtle) */
frame {
    border: 1px solid @strong-border-color;
    border-radius: 4px;
    padding: 2px;
}
frame border {
    background-image: none;
    border: 0;
}
.gimp-offset-area-frame {
    border: solid 2px @stronger-border-color;
    background-color: @widget-bg-color;
}

/* Switches & Scales (Gruvbox accents) */
switch {
    background-color: @widget-bg-color;
    border: 1px solid @strong-border-color;
    border-radius: 20px;
    min-height: 20px;
}
switch:checked {
    background-color: @theme_green;  /* #73A857 dark green */
}
scale slider {
    background-color: @widget-bg-color;
    border: 1px solid @strong-border-color;
    border-radius: 50%;
}
scale trough {
    background-color: @stronger-border-color;
    border-radius: 4px;
}

/* Dialogs & Action Bars */
GtkDialog {
    border: 1px solid @border-color;
}
.actionbar, .dialog-action-box {
    background-color: @widget-bg-color;
    border-top: 1px solid @stronger-border-color;
    padding: 4px;
}
.actionbar revealer box {
    border-top: 1px solid @strong-border-color;
}

/* Rulers & Canvas (Transparent grid) */
GimpRuler {
    background-color: @ruler-color;
}
#gimp-canvas {
    color: @dimmed-fg-color;
}
GimpDisplayShell grid > button {
    min-height: 0;
    min-width: 0;
    padding: 0;
    background-color: transparent;
}
GimpDisplayShell progressbar trough, GimpDisplayShell progressbar progress {
    min-height: 1em;
}
GimpFileDialog progressbar trough, GimpFileDialog progressbar progress {
    min-width: 1px;
    min-height: 1em;
}

/* Path Bar (File dialogs) */
#pathbarbox button:hover {
    background-color: @hover-color;
}

/* Image Menu Bar */
#image-menubar, GtkImageMenuItem {
    background-color: @bg-color;
    color: @fg-color;
}

/* Combobox Dropdowns */
combobox window.popup, combobox window {
    background-color: @widget-bg-color;
    color: @fg-color;
}
combobox box, combobox box.linked, combobox button {
    background-color: transparent;
    border-color: @stronger-border-color;
    color: @fg-color;
}
combobox arrow {
    -gtk-icon-shadow: none;
}

/* ListBox Rows */
list, list row {
    background-color: @widget-bg-color;
}
list row:selected {
    background-color: @selected-color;
}
list row:hover {
    background-color: @hover-color;
}

/* TextView (e.g., layer names) */
textview text, textview {
    background-color: @extreme-bg-color;
    color: @fg-color;
}
textview text selection {
    background-color: @fg-color;
    color: @bg-color;
}

/* Checkboxes/Radios (Flat, rounded) */
checkbutton check, radiobutton radio, treeview.view check {
    background-color: @extreme-bg-color;
    border: 1px solid @stronger-border-color;
    border-radius: 3px;
}
checkbutton check:checked, radiobutton radio:checked {
    background-color: @selected-color;
    color: @fg-color;
}
checkbutton check:disabled, radiobutton radio:disabled {
    background-color: @bg-color;
    color: @disabled-fg-color;
}
checkbutton:checked label {
    font-weight: bold;
}

/* Tool Dialogs & Overlay */
GimpToolDialog {
    -GtkDialog-action-area-border: 1px;
}
GimpOverlayDialog button {
    padding: 0 2px;
}

/* Color Selection (gimpcolordialog) */
GimpColorSelection ColorselCmyk {
    padding: 2px;
}
GimpColorHistory button {
    padding: 3px;
}
#gimp-color-tag-box button {
    padding: 4px 6px;
}
tab GimpFgBgView {
    padding: 6px;
}
GimpFgBgEditor:active {
    border-width: 1px;
}
GimpColorNotebook .frame {
    border-color: @bg-color;
}

/* About Dialog Credits */
.gimp-about-dialog box box stack scrolledwindow viewport grid {
    background-color: @extreme-bg-color;
}

/* Sidebar (File open) */
.sidebar-row, .sidebar-row * {
    background-color: @widget-bg-color;
}
.sidebar-row:selected, .sidebar-row:selected * {
    background-color: @selected-color;
}
.sidebar-row:hover, .sidebar-row:hover * {
    background-color: @hover-color;
}

/* Paned Separators */
paned separator {
    color: @border-color;
    background-color: @border-color;
    background-position: center;
    background-repeat: no-repeat;
    background-size: auto;
    padding: 1px;
}

/* Image Buttons (No blur) */
.image-button image, button image {
    -gtk-icon-shadow: 0 0 transparent;
}

/* Wilber Icon (Toolbox) */
GimpDock frame:first-child:not(label) {
    color: @dimmed-fg-color;
}
GimpDock frame:first-child label {
    color: @fg-color;
}

/* Offset Area Frame */
.gimp-offset-area-frame {
    border: solid 2px @stronger-border-color;
    background-color: @widget-bg-color;
}

/* Sample Point Editor */
GimpSamplePointEditor box.vertical {
    background-color: transparent;
}

/* Unit ComboBox */
GimpUnitComboBox {
    -GtkComboBox-appears-as-list: 0;
}
    ]]
  end
  if not utils.write_to_file(gimp_css_path, gimp_css_content) then
    utils.log("Failed to write GIMP CSS to " .. gimp_css_path, vim.log.levels.ERROR, false)
  end
end

return M
