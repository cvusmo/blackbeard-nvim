-- ~/blackbeard-nvim/lua/blackbeard/gimp.lua
local M = {}
local utils = require("blackbeard.utils")

local home = os.getenv("HOME")

function M.update_theme(theme)
  -- Ensure GIMP dir exists
  local gimp_dir = home .. "/.config/GIMP/3.0"
  vim.fn.mkdir(gimp_dir, "p") -- Create if missing

  local gimp_css_path = gimp_dir .. "/gimp.css"
  local import_path = "file://" .. home .. "/.local/share/themes/blackbeard-" .. theme .. "/gtk-3.0/gtk.css"
  local gimp_css_content
  if theme == "light" then
    gimp_css_content = [[
    /* Blackbeard Light for GIMP - Gruvbox-inspired clean theme */
    @import url("]] .. import_path .. [[");  /* Your custom GTK3 CSS */

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
    @define-color theme_green           #4A7C2A;  /* Gruvbox-inspired light green */
    @define-color theme_selected_bg_color #F4A259;  /* Matches selected-color */

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
    @import url("]] .. import_path .. [[");  /* Your custom GTK3 CSS */

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
    @define-color theme_green           #4A7C2A;  /* Gruvbox-inspired light green */
    @define-color theme_selected_bg_color #F4A259;  /* Matches selected-color */

/* Global GIMP Styles (From provided CSS, customized) */
* { 
GimpToolDialog {
    -GtkDialog-action-area-border: 1;
}

GimpColorNotebook tab {
    padding: 0 0 0 0;
}

GimpDock entry,
GimpDock spinbutton,
GimpDock GimpColorNotebook spinbutton,
GimpDock GimpColorNotebook spinbutton entry,
GimpDock GimpColorScales spinbutton,
GimpDock GimpColorScales spinbutton entry {
    min-height: 0;
    padding-top: 2px;
    padding-bottom: 2px;
}

GimpColorSelection ColorselCmyk {
    padding: 2px 2px 2px 2px;
}

GimpColorHistory button {
    padding: 3px 3px 3px 3px;
}

#gimp-color-tag-box button {
    padding: 4px 6px 4px 6px;
}

tab GimpFgBgView {
    padding: 6px 6px 6px 6px;
}

GimpFgBgEditor:active {
    border-width: 1px 1px 1px 1px;
}

GimpDock notebook tab {
    padding: 0 0 0 0;
}

GimpDock :not(toolbutton) > button,
GimpOverlayDialog button,
GimpToolDialog :not(headerbar) button,
GimpTextStyleEditor button {
    padding: 0px 2px 0px 2px;
}

GimpToolDialog headerbar {
    min-height: 0;
}

GimpDock frame {
    -GimpFrame-label-bold:       0;
    -GimpFrame-label-spacing:    2;
}

GimpDisplayShell grid > button {
    min-height: 0;
    min-width: 0;
    padding: 0 0 0 0;
}

GimpDisplayShell progressbar trough,
GimpDisplayShell progressbar progress {
    min-height: 1em;
}

GimpFileDialog progressbar trough,
GimpFileDialog progressbar progress {
    min-width: 1px; /* hack */
    min-height: 1em;
}

spinbutton entry {
    border-radius: 3px;
}

GimpSpinScale entry {
    /* Important: prevent overhigh spin scale */
    min-height: 16px;
}

GimpSpinScale entry progress {
    background-color: @theme_selected_bg_color;
    border-width:     0px;
    border-radius:    3px;
}

GimpSpinScale button {
    /* Makes the +- buttons a bit more compact. */
    padding: 0 1px 0 1px;
}

entry.italic {
    font-style: italic;
}

tooltip decoration {
  box-shadow: 0px 0px;
}

treeview header button {
    padding: 6px;
}

treeview .toggle-icon:not(.visible):hover {
    border: 1px solid gray;
    border-radius: 3px;
}

treeview .toggle-icon:not(.visible):selected {
    border-color: lightgray;
}

* {
   /* Default text color; needed for e.g. the Prefs dialog title area,
    * which doesn't have any more specific way to style it.
    */
   color: @fg-color;
 }
 
 *:disabled {
   color: @disabled-fg-color;
 }
 
 #image-menubar, GtkImageMenuItem {
   background-color: @bg-color;
   color: @fg-color;
 }
 
 /* TreeViews, e.g. in a file picker or the Prefs dialog */
 .view {
   background-color: @extreme-bg-color;
   color: @fg-color;
 }
 
 /* Selected items in a treeview list. */
 .view:selected {
   background-color: @extreme-selected-color;
   color: @fg-color;
 }
 
 .view:disabled {
   color: @disabled-fg-color;
 }
 
 /* Selected text in a treeview cell (e.g. layer name in edition mode). */
 .view selection {
   background-color: @fg-color;
   color: @bg-color;
 }
 
 .view header button {
   background-color: @bg-color;
   border: 1px solid @stronger-border-color;
 }
 
 /* Define the mouse-over color for the path
  * buttons in the various file dialogs.
  */
 #pathbarbox button:hover {
   background-color: @hover-color;
 }
 
 /* The main image window before it has an image in it,
  * and the buttonbar along the bottoms of dialogs.
  * Foreground color here is the text color, not the Wilber color.
  * background-color and background here are ignored.
  */
 GimpDisplayShell, GimpDock, .dialog-action-box, .dialog-vbox {
   color: @dimmed-fg-color;
 }
 
 /* Prevent system theme leak that adds a border around
  * the toolbox Wilber */
 GimpDock frame border {
   background-image: none;
 }
 
 /* Foreground color for the big Wilber in the empty image window.
  * Again, background-color and background here are ignored.
  */
 gimp-canvas {
   background-color: aquamarine;
 }
 
 /* Prevent system theme leak that affects the color of the
  * main canvas and some widget containers  */
 stack {
   background-image: none;
 }
 
 /* GtkTextView */
 textview text, textview {
   background-color: @extreme-bg-color;
   color: @fg-color;
 }
 /* End GtkTextView */
 
 combobox window.popup, combobox window {
   background-image: none;
   background-color: @widget-bg-color;
   color: @fg-color;
 }
 
 combobox box, combobox box.linked, combobox button {
   color: @fg-color;
   background-image: none;
   border-color: @stronger-border-color;
 }
 
 /* Remove "corners" around the combo boxes */
 combobox box, combobox box.linked {
   background-color: transparent;
 }
 
 combobox button {
   background-color: @widget-bg-color;
 }
 
 combobox arrow, combobox button * {
   -gtk-icon-shadow: none;
 }
 
 /* Define colors so the nib handle appears in Gimp Ink Options */
 GimpBlobEditor {
   color: @fg-color;
   background-color: @bg-color;
   border: 0.1em solid @fg-color;
 }
 
 /* Get rid of the outline around all tabs in the gimpcolordialog */
 GimpColorNotebook .frame {
   border-color: @bg-color;
 }
 
 /* Color history buttons in the color chooser.
  * The selector GimpColorHistory button gets the color buttons
  * but not the + button; GimpColorSelection gets both.
  */
 GimpColorSelection button {
   background: @widget-bg-color;
   border: 0px solid @stronger-border-color;
   color: @fg-color;
 }
 
 GimpColorSelection button:hover {
   background: @hover-color;
 }
 
 /* The tabs above the color selector */
 notebook stack {
   background-color: @bg-color;
 }
 
 notebook header {
   background-color: @bg-color;
   border-color: @edge-border-color;
 }
 
 notebook header button {
   box-shadow: none;
 }
 
 /* Use this to make a border or padding around each tab */
 notebook header tabs tab {
   background-color: @bg-color;
   background-image: none;
   border: 1px solid @strong-border-color;
   box-shadow: none;
   margin-left: 2px;
   margin-right: 2px;
   min-width: 30px;
   min-height: 30px;
   padding: 1px;
 }
 
 /* The underline for selected tabs */
 notebook header tabs tab:checked {
   background-color: @selected-color;
   box-shadow: 0 -4px @stronger-border-color inset;
 }
 
 notebook header tabs tab:hover {
   background-color: @hover-color;
 }
 
 /* Add margin to image tabs so the close button fits */
 notebook header tabs tab > box > button
 {
   margin-right: 5px;
 }
 
 /* The Close button on image tabs */
 .reorderable-page button {
   background-color: transparent;
 }
 
 /* The background of many dialogs, e.g. Preferences and gimpcolordialog */
 .vertical {
   color: @fg-color;
   background-color: @bg-color;
   background-image: none;
 }
 
 /* Background for many button bars and dialog titles.
  * Also, unexpectedly, controls the prefs "Reload Current Theme" button content.
  *
  * Warning: setting a background-color here "breaks" the marks added by
  * gtk_scale_add_mark() on a GtkScale. I'm still unsure why, but the conclusion
  * is probably that it's a bad idea to set too broad background-color rules.
  */
 .horizontal {
   color: @fg-color;
 }
 
 /* Text buttons, e.g. the main buttons at the bottoms of dialogs,
  * 0..100 and 0..255 at the top of gimpcolordialog,
  * where they're inside a GimpColorSelection
  */
 .text-button {
   color: @fg-color;
   background-color: @widget-bg-color;
   background-image: none;
   font-weight: normal;
 }
 
 .text-button:hover {
   background-color: @hover-color;
 }
 
 /* .flat covers the tool buttons and the buttons at the bottom
  * of the Toolbox window.
 */
 
 toolbutton button.flat {
   background-color: @bg-color; /* MODIFIED: Matched to main background */
   color: @fg-color;
 }
 
 toolbutton button.flat:hover {
   background: @selected-color;
   border: 1px solid @edge-border-color;
 }
 
 toolbutton button.flat:checked,
 toolbutton button.flat:checked:hover,
 .image-button:hover, viewport button:hover {
   background: @selected-color;
 }
 
 /* Visual indication of clicking an already
  * selected button
  */
 toolbutton button.flat:checked:active:hover {
   background-color: @hover-color;
   border-color: @hover-color;
 }
 
 /* Style for GtkToolBar, primarily used in plug-ins
  * with toolbars like Image Map and Animation Play */
 toolbar {
   background-color: @widget-bg-color;
 }

 treeview {
  background-color: @main_color;
  }
  
  treeview header button {
      padding: 6px;
  }
  
  treeview .toggle-icon:not(.visible):hover {
      border: 1px solid gray;
      border-radius: 3px;
  }
  
  treeview .toggle-icon:not(.visible):selected {
      border-color: lightgray;
  }
  
  /* MODIFIED: Replaced gradient with solid color */
  treeview.view:selected,
  treeview.view:selected:focus {
      background-color: @selected-color;
      border-radius: 0;
  }
  
  box {
  background-color: @main_color;
  }
  
  
  grid {
  background-color: @main_color;
  }
  
  /* Gimp canvas */
  
  
  GimpDisplayShell grid {
  
      background-color: @canva;
  
      
  } 
   

  /* Ruler */

  GimpRuler {

    color: @fg2-color;
       
   }

 
 /* Prevent overly thick border around image buttons */
 .image-button image, button image {
   -gtk-icon-shadow: 0 0 transparent;
 }
 
 /* Color the toolbox Wilber icon */
 GimpDock frame:first-child:not(label) {
   color: @dimmed-fg-color;
 }
 /* Fix an issue with a few labels in the toolbox
  * having their colors overwritten with Wilber's
  */
 GimpDock frame:first-child label {
   color: @fg-color;
 }
 
 /* Defining slider scale border and trough */
 scale contents trough
 {
   border-color: @strong-border-color;
   background-color: @ruler-color;
 }
 
 scrollbar {
   background-color: @bg-color;
   border-color: @border-color;
 }
 
 /*
 Worth trying for always-visible scrollbar:
 https://stackoverflow.com/questions/52414202/gtkscrolledwindow-how-to-always-show-the-overlay-scrollbar
 Doesn't seem to work here, though.
  */
 scrollbar trough {
   background: @scrollbar-trough-color;
 }
 
 scrollbar slider {
   background: @scrollbar-slider-color;
   border: 2px solid @border-color;
 }
 
 scrolledwindow {
   border-color: @edge-border-color;
 }
 
 /* Removes black border around scrolled windows */
 scrolledwindow viewport grid, scrolledwindow viewport box {
   border-radius: 1px;
   border: 0px solid @bg-color;
 }
 
 /* Defining background color for About Dialog credits box */
 .gimp-about-dialog box box stack scrolledwindow viewport grid {
   background-color: @extreme-bg-color;
 }
 
 GimpRuler {
   background-color: @ruler-color;
 }
 
 /* Make sure the sample point numbers are visible */
 GimpSamplePointEditor box.vertical {
   background-color: transparent;
 }
 
 entry {
   background-color: @extreme-bg-color;
   color: @fg-color;
 }
 
 entry selection {
   background-color: @fg-color;
   color: @bg-color;
 }
 
 
 paned menu separator {
     padding: 0px;
 }
 
 .view button {
   background-color: @bg-color;
   border-color: @border-color;
   color: @fg-color;
 }
 
 button {
   background-image: none;
   background-color: @widget-bg-color; /* MODIFIED */
   text-shadow: 0 0;
 }
 
 /* Handle both buttons drawn directly and drawn with an icon. */
 button:disabled, button:disabled image {
   color: @disabled-button-color;
 }
 
 /* E.g. the currently active action of a dialog will slightly stand out so that
  * people know what action is activated when they will just hit Enter.
  */
 button.default {
   border: 1px solid shade(@fg-color, 0.7);
 }
 
 button:not(.flat)
 {
   border-color: @edge-border-color;
 }
 
 /* Styling for dockable dialog footer buttons */
 button.titlebutton
 {
   border-color: transparent;
   box-shadow: none;
 }
 
 button:checked, button.titlebutton:hover {
   background: @selected-color;
   border-color: @edge-border-color;
 }
 
 /* This is the default active action, the somehow "suggested" action. Usually it
  * means this is either the expected next step action (e.g. activating a
  * filter), or else the less destructive action (e.g. when closing an unsaved
  * image, the default is "Cancel").
  */
 button.suggested-action {
   border: 1px solid shade(@fg-color, 0.8);
 }
 
 /* The "destructive" action will be for instance the "Delete Layer"
  * button when pasting as floating data.
  */
 button.destructive-action {
   border: 1px dashed shade(@fg-color, 0.8)
 }
 
 /* Spinbuttons: there are two kinds:
  * spinbutton, spinbutton button
  * e.g. the "width" field in the New Image dialog.
  * spinbutton button.down, spinbutton button.up can be styled separately,
  * as can spinbutton entry.
  *
  * GimpSpinScale also has button.up, button.down and entry under it,
  * plus GimpSpinScale entry progress.
  *
  * Mostly the inherited values seem pretty good for both of these,
  * so they're not overridden.
  */
 
 spinbutton, entry {
   /* Borders are a bit darker, but not too dark. */
   border-color: @strong-border-color;
 }
 
 spinbutton
 {
   background-image: none;
   background-color: @bg-color;
 }
 
 /* Styling for the +/- buttons */
 spinbutton button.up, spinbutton button.down {
   background-color: @bg-color;
  GimpToolDialog {
    -GtkDialog-action-area-border: 1;
}

GimpColorNotebook tab {
    padding: 0 0 0 0;
}

GimpDock entry,
GimpDock spinbutton,
GimpDock GimpColorNotebook spinbutton,
GimpDock GimpColorNotebook spinbutton entry,
GimpDock GimpColorScales spinbutton,
GimpDock GimpColorScales spinbutton entry {
    min-height: 0;
    padding-top: 2px;
    padding-bottom: 2px;
}

GimpColorSelection ColorselCmyk {
    padding: 2px 2px 2px 2px;
}

GimpColorHistory button {
    padding: 3px 3px 3px 3px;
}

#gimp-color-tag-box button {
    padding: 4px 6px 4px 6px;
}

tab GimpFgBgView {
    padding: 6px 6px 6px 6px;
}

GimpFgBgEditor:active {
    border-width: 1px 1px 1px 1px;
}

GimpDock notebook tab {
    padding: 0 0 0 0;
}

GimpDock :not(toolbutton) > button,
GimpOverlayDialog button,
GimpToolDialog :not(headerbar) button,
GimpTextStyleEditor button {
    padding: 0px 2px 0px 2px;
}

GimpToolDialog headerbar {
    min-height: 0;
}

GimpDock frame {
    -GimpFrame-label-bold:       0;
    -GimpFrame-label-spacing:    2;
}

GimpDisplayShell grid > button {
    min-height: 0;
    min-width: 0;
    padding: 0 0 0 0;
}

GimpDisplayShell progressbar trough,
GimpDisplayShell progressbar progress {
    min-height: 1em;
}

GimpFileDialog progressbar trough,
GimpFileDialog progressbar progress {
    min-width: 1px; /* hack */
    min-height: 1em;
}

spinbutton entry {
    border-radius: 3px;
}

GimpSpinScale entry {
    /* Important: prevent overhigh spin scale */
    min-height: 16px;
}

GimpSpinScale entry progress {
    background-color: @theme_selected_bg_color;
    border-width:     0px;
    border-radius:    3px;
}

GimpSpinScale button {
    /* Makes the +- buttons a bit more compact. */
    padding: 0 1px 0 1px;
}

entry.italic {
    font-style: italic;
}

tooltip decoration {
  box-shadow: 0px 0px;
}

treeview header button {
    padding: 6px;
}

treeview .toggle-icon:not(.visible):hover {
    border: 1px solid gray;
    border-radius: 3px;
}

treeview .toggle-icon:not(.visible):selected {
    border-color: lightgray;
}

/* A set of interface style definitions common to light and dark theme variants for GIMP 3.0
 * The specific dark and light interface styles are defined in common-light.css, common-dark.css */

/* The specific dark and light colors are defined in gimp-dark.css, gimp.css */

/* Do not import this file directly from gimp.css or gimp-dark.css files, you will miss light/dark theme specific styles.
 * Do import matching common-[dark,light].css */


/* Hint for debugging themes:
 * first enable the GTK inspector with
   gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true
 * then (after restarting GIMP) call it up with ctrl+shift+i
 * or from GIMP's UI: File > Debug > Start GtkInspector
 */


 * {
   /* Default text color; needed for e.g. the Prefs dialog title area,
    * which doesn't have any more specific way to style it.
    */
   color: @fg-color;
 }
 
 *:disabled {
   color: @disabled-fg-color;
 }
 
 #image-menubar, GtkImageMenuItem {
   background-color: @bg-color;
   color: @fg-color;
 }
 
 /* TreeViews, e.g. in a file picker or the Prefs dialog */
 .view {
   background-color: @extreme-bg-color;
   color: @fg-color;
 }
 
 /* Selected items in a treeview list. */
 .view:selected {
   background-color: @extreme-selected-color;
   color: @fg-color;
 }
 
 .view:disabled {
   color: @disabled-fg-color;
 }
 
 /* Selected text in a treeview cell (e.g. layer name in edition mode). */
 .view selection {
   background-color: @fg-color;
   color: @bg-color;
 }
 
 .view header button {
   background-color: @bg-color;
   border: 1px solid @stronger-border-color;
 }
 
 /* Define the mouse-over color for the path
  * buttons in the various file dialogs.
  */
 #pathbarbox button:hover {
   background-color: @hover-color;
 }
 
 /* The main image window before it has an image in it,
  * and the buttonbar along the bottoms of dialogs.
  * Foreground color here is the text color, not the Wilber color.
  * background-color and background here are ignored.
  */
 GimpDisplayShell, GimpDock, .dialog-action-box, .dialog-vbox {
   color: @dimmed-fg-color;
 }
 
 /* Prevent system theme leak that adds a border around
  * the toolbox Wilber */
 GimpDock frame border {
   background-image: none;
 }
 
 /* Foreground color for the big Wilber in the empty image window.
  * Again, background-color and background here are ignored.
  */
 gimp-canvas {
   background-color: aquamarine;
 }
 
 /* Prevent system theme leak that affects the color of the
  * main canvas and some widget containers  */
 stack {
   background-image: none;
 }
 
 /* GtkTextView */
 textview text, textview {
   background-color: @extreme-bg-color;
   color: @fg-color;
 }
 /* End GtkTextView */
 
 combobox window.popup, combobox window {
   background-image: none;
   background-color: @widget-bg-color;
   color: @fg-color;
 }
 
 combobox box, combobox box.linked, combobox button {
   color: @fg-color;
   background-image: none;
   border-color: @stronger-border-color;
 }
 
 /* Remove "corners" around the combo boxes */
 combobox box, combobox box.linked {
   background-color: transparent;
 }
 
 combobox button {
   background-color: @widget-bg-color;
 }
 
 combobox arrow, combobox button * {
   -gtk-icon-shadow: none;
 }
 
 /* Define colors so the nib handle appears in Gimp Ink Options */
 GimpBlobEditor {
   color: @fg-color;
   background-color: @bg-color;
   border: 0.1em solid @fg-color;
 }
 
 /* Get rid of the outline around all tabs in the gimpcolordialog */
 GimpColorNotebook .frame {
   border-color: @bg-color;
 }
 
 /* Color history buttons in the color chooser.
  * The selector GimpColorHistory button gets the color buttons
  * but not the + button; GimpColorSelection gets both.
  */
 GimpColorSelection button {
   background: @widget-bg-color;
   border: 0px solid @stronger-border-color;
   color: @fg-color;
 }
 
 GimpColorSelection button:hover {
   background: @hover-color;
 }
 
 /* The tabs above the color selector */
 notebook stack {
   background-color: @bg-color;
 }
 
 notebook header {
   background-color: @bg-color;
   border-color: @edge-border-color;
 }
 
 notebook header button {
   box-shadow: none;
 }
 
 /* Use this to make a border or padding around each tab */
 notebook header tabs tab {
   background-color: @bg-color;
   background-image: none;
   border: 1px solid @strong-border-color;
   box-shadow: none;
   margin-left: 2px;
   margin-right: 2px;
   min-width: 30px;
   min-height: 30px;
   padding: 1px;
 }
 
 /* The underline for selected tabs */
 notebook header tabs tab:checked {
   background-color: @selected-color;
   box-shadow: 0 -4px @stronger-border-color inset;
 }
 
 notebook header tabs tab:hover {
   background-color: @hover-color;
 }
 
 /* Add margin to image tabs so the close button fits */
 notebook header tabs tab > box > button
 {
   margin-right: 5px;
 }
 
 /* The Close button on image tabs */
 .reorderable-page button {
   background-color: transparent;
 }
 
 /* The background of many dialogs, e.g. Preferences and gimpcolordialog */
 .vertical {
   color: @fg-color;
   background-color: @bg-color;
   background-image: none;
 }
 
 /* Background for many button bars and dialog titles.
  * Also, unexpectedly, controls the prefs "Reload Current Theme" button content.
  *
  * Warning: setting a background-color here "breaks" the marks added by
  * gtk_scale_add_mark() on a GtkScale. I'm still unsure why, but the conclusion
  * is probably that it's a bad idea to set too broad background-color rules.
  */
 .horizontal {
   color: @fg-color;
 }
 
 /* Text buttons, e.g. the main buttons at the bottoms of dialogs,
  * 0..100 and 0..255 at the top of gimpcolordialog,
  * where they're inside a GimpColorSelection
  */
 .text-button {
   color: @fg-color;
   background-color: @widget-bg-color;
   background-image: none;
   font-weight: normal;
 }
 
 .text-button:hover {
   background-color: @hover-color;
 }
 
 /* .flat covers the tool buttons and the buttons at the bottom
  * of the Toolbox window.
 */
 
 toolbutton button.flat {
   background-color: @bg-color; /* MODIFIED: Matched to main background */
   color: @fg-color;
 }
 
 toolbutton button.flat:hover {
   background: @selected-color;
   border: 1px solid @edge-border-color;
 }
 
 toolbutton button.flat:checked,
 toolbutton button.flat:checked:hover,
 .image-button:hover, viewport button:hover {
   background: @selected-color;
 }
 
 /* Visual indication of clicking an already
  * selected button
  */
 toolbutton button.flat:checked:active:hover {
   background-color: @hover-color;
   border-color: @hover-color;
 }
 
 /* Style for GtkToolBar, primarily used in plug-ins
  * with toolbars like Image Map and Animation Play */
 toolbar {
   background-color: @widget-bg-color;
 }

 treeview {
  background-color: @main_color;
  }
  
  treeview header button {
      padding: 6px;
  }
  
  treeview .toggle-icon:not(.visible):hover {
      border: 1px solid gray;
      border-radius: 3px;
  }
  
  treeview .toggle-icon:not(.visible):selected {
      border-color: lightgray;
  }
  
  /* MODIFIED: Replaced gradient with solid color */
  treeview.view:selected,
  treeview.view:selected:focus {
      background-color: @selected-color;
      border-radius: 0;
  }
  
  box {
  background-color: @main_color;
  }
  
  
  grid {
  background-color: @main_color;
  }
  
  /* Gimp canvas */
  
  
  GimpDisplayShell grid {
  
      background-color: @canva;
  
      
  } 
   

  /* Ruler */

  GimpRuler {

    color: @fg2-color;
       
   }

 
 /* Prevent overly thick border around image buttons */
 .image-button image, button image {
   -gtk-icon-shadow: 0 0 transparent;
 }
 
 /* Color the toolbox Wilber icon */
 GimpDock frame:first-child:not(label) {
   color: @dimmed-fg-color;
 }
 /* Fix an issue with a few labels in the toolbox
  * having their colors overwritten with Wilber's
  */
 GimpDock frame:first-child label {
   color: @fg-color;
 }
 
 /* Defining slider scale border and trough */
 scale contents trough
 {
   border-color: @strong-border-color;
   background-color: @ruler-color;
 }
 
 scrollbar {
   background-color: @bg-color;
   border-color: @border-color;
 }
 
 /*
 Worth trying for always-visible scrollbar:
 https://stackoverflow.com/questions/52414202/gtkscrolledwindow-how-to-always-show-the-overlay-scrollbar
 Doesn't seem to work here, though.
  */
 scrollbar trough {
   background: @scrollbar-trough-color;
 }
 
 scrollbar slider {
   background: @scrollbar-slider-color;
   border: 2px solid @border-color;
 }
 
 scrolledwindow {
   border-color: @edge-border-color;
 }
 
 /* Removes black border around scrolled windows */
 scrolledwindow viewport grid, scrolledwindow viewport box {
   border-radius: 1px;
   border: 0px solid @bg-color;
 }
 
 /* Defining background color for About Dialog credits box */
 .gimp-about-dialog box box stack scrolledwindow viewport grid {
   background-color: @extreme-bg-color;
 }
 
 GimpRuler {
   background-color: @ruler-color;
 }
 
 /* Make sure the sample point numbers are visible */
 GimpSamplePointEditor box.vertical {
   background-color: transparent;
 }
 
 entry {
   background-color: @extreme-bg-color;
   color: @fg-color;
 }
 
 entry selection {
   background-color: @fg-color;
   color: @bg-color;
 }
 
 
 paned menu separator {
     padding: 0px;
 }
 
 .view button {
   background-color: @bg-color;
   border-color: @border-color;
   color: @fg-color;
 }
 
 button {
   background-image: none;
   background-color: @widget-bg-color; /* MODIFIED */
   text-shadow: 0 0;
 }
 
 /* Handle both buttons drawn directly and drawn with an icon. */
 button:disabled, button:disabled image {
   color: @disabled-button-color;
 }
 
 /* E.g. the currently active action of a dialog will slightly stand out so that
  * people know what action is activated when they will just hit Enter.
  */
 button.default {
   border: 1px solid shade(@fg-color, 0.7);
 }
 
 button:not(.flat)
 {
   border-color: @edge-border-color;
 }
 
 /* Styling for dockable dialog footer buttons */
 button.titlebutton
 {
   border-color: transparent;
   box-shadow: none;
 }
 
 button:checked, button.titlebutton:hover {
   background: @selected-color;
   border-color: @edge-border-color;
 }
 
 /* This is the default active action, the somehow "suggested" action. Usually it
  * means this is either the expected next step action (e.g. activating a
  * filter), or else the less destructive action (e.g. when closing an unsaved
  * image, the default is "Cancel").
  */
 button.suggested-action {
   border: 1px solid shade(@fg-color, 0.8);
 }
 
 /* The "destructive" action will be for instance the "Delete Layer"
  * button when pasting as floating data.
  */
 button.destructive-action {
   border: 1px dashed shade(@fg-color, 0.8)
 }
 
 /* Spinbuttons: there are two kinds:
  * spinbutton, spinbutton button
  * e.g. the "width" field in the New Image dialog.
  * spinbutton button.down, spinbutton button.up can be styled separately,
  * as can spinbutton entry.
  *
  * GimpSpinScale also has button.up, button.down and entry under it,
  * plus GimpSpinScale entry progress.
  *
  * Mostly the inherited values seem pretty good for both of these,
  * so they're not overridden.
  */
 
 spinbutton, entry {
   /* Borders are a bit darker, but not too dark. */
   border-color: @strong-border-color;
 }
 
 spinbutton
 {
   background-image: none;
   background-color: @bg-color;
 }
 
 /* Styling for the +/- buttons */
 spinbutton button.up, spinbutton button.down {
   background-color: @bg-color;
   -gtk-icon-shadow: none;
 }
 
 GimpSpinScale entry progress {
   background-color: @extreme-selected-color;
   border-width:     0px;
   border-radius:    3px;
 }
 
 GimpSpinScale button
 {
   border-color: @border-color;
   -gtk-icon-shadow: none;
 }
 
 /* Checkboxes */
 checkbutton, checkbutton.text-button, radiobutton, radiobutton.text-button, checkbutton label {
   color: @fg-color;
   background-color: @bg-color;
 }
 
 checkbutton:hover, checkbutton.text-button:hover, checkbutton:hover label, radiobutton:hover, checkbutton label:hover {
   color: @fg-color;
   background-color: @hover-color;
 }
 
 checkbutton check, radiobutton radio, treeview.view check {
   background-image: none;
   background-color: @extreme-bg-color;
   border: 1px solid @stronger-border-color;
 }
 
 checkbutton check:checked {
   color: @fg-color;
 }
 
 checkbutton check:disabled {
   color: @disabled-fg-color;
   background-color: @bg-color;
 }
 
 checkbutton:checked label, radiobutton:checked label {
   font-weight: bold;
 }
 
 /* Some plugins have radio buttons, e.g. Fractal Explorer */
 radio {
   background-image: none;
   background-color: @extreme-bg-color;
   border: 1px solid @stronger-border-color;
   border-radius: 100%;
   color: @fg-color;
 }
 
 /* Removes "blurred" effect from tooltip label */
 tooltip {
   background-color: @bg-color;
   background-image: none;
   border: 1px solid @edge-border-color;
   text-shadow: 0 0;
 }
 
 tooltip box
 {
   background-color: @bg-color;
   border: 0px solid @transparent;
 }
 
 /* Prevents flickering effect on some desktops */
 tooltip decoration {
   box-shadow: 0px 0px;
 }
 
 /* The border around a tooltip */
 .background {
   background-color: @bg-color;
   border-color: @border-color;
   border-width: 1px;
 }
 
 /* The border around a frame */
 border {
   border: 0.1px;
 }
 
 /* The border around GimpOffsetArea frame in resize dialogs */
 .gimp-offset-area-frame {
   border: solid 2px @stronger-border-color;
   background-color: @widget-bg-color;
 }
 
 /* For dropdown menus (e.g. "px" when creating a new image */
 #gtk-combobox-popup-menu {
   background-color: @bg-color;
   color: @fg-color;
 }
 
 /* Top menu items  */
 
 /* give the menu bar a color, fix for the default color being too dark */
 menubar {
   background-color: @bg-color;
   background-image: none;
   box-shadow: 0 -1px @edge-border-color inset;
 }
 
 menuitem:hover, menuitem:selected
 {
   border: 0px solid transparent;
 }
 
 /* The top menu item itself: File, Edit ... */
 menuitem menuitem {
   color: @fg-color;
   background: @extreme-bg-color;
 }
 
 /* A top (File, Edit) menubar item when its menu is expanded. */
 menubar > menuitem:hover {
   color: @fg-color;
   background: @extreme-bg-color;
 }
 
 /* Top menubar subitem style */
 menubar menu menuitem {
   color: @fg-color;
   background-color: @bg-color;
 }
 
 menubar menu menuitem:hover {
   color: @fg-color;
   background-color: @extreme-bg-color;
 }
 
 menuitem *:hover {
   color: @fg-color;
   background: @extreme-selected-color;
 }
 
 menuitem check {
   border-color: @fg-color;
 }
 
 menuitem decoration
 {
   box-shadow: 0 1px 2px @edge-border-color;
 }
 
 /* "Add Tab" menu in dockable dialog */
 menu {
   background-color: @bg-color;
 }
 
 /* Fixes issue with top menu label not changing
  * colors when highlighted
  */
 menu box {
   background-color: transparent;
 }
 
 /* In some cases, the GtkSeparatorMenuItem-s get very ugly top/bottom margin
  * with a different background color. Let's get rid of it.
  */
 menu separator {
   background-color: @stronger-border-color;
   margin: 0;
 }
 
 /* Defines the border around the Save Image actionbar options */
 actionbar revealer box {
   border-width: 0px;
   border-top-width: 1px;
   border-top-color: @strong-border-color;
 }
 
 /* Sidebar in File > Open */
 
 /* The background to either side of the directory buttons.
  * The color of the buttons themselves comes from somewhere else.
  */
 .sidebar-row, .sidebar-row * {
   background-color: @widget-bg-color;
 }
 
 .sidebar-row:selected, .sidebar-row:selected * {
   background-color: @selected-color;
 }
 
 .sidebar-row:hover, .sidebar-row:hover * {
   background-color: @bg-color;
 }
 
 /* GtkListBox widgets */
 
 list, list row {
   background-color: @widget-bg-color;
 }
 
 list row:selected {
   background-color: @selected-color;
 }
 
 list row:hover {
   background-color: @hover-color;
 }
 
 /* GtkSwitch buttons */
 
 switch {
   background-color: @bg-color;
   border: 1px solid @stronger-border-color;
 }
 
 /* The switch button is hard to understand without color.
  * Let's indicate the checked state with foreground color.
  */
 switch:checked {
   background-color: @fg-color;
 }
 
 /* This prevents the 1/0 labels from appearing inside the switch slider */
 switch image {
   color: transparent;
 }
 
 headerbar {
   min-height: 36px;
   background-color: @bg-color;
   background-image: none;
   border-color: @sap;
   outline-color: @sap;
   box-shadow: none;
   border-radius: 10px;
 }
 
 headerbar:backdrop * {
   color: @disabled-fg-color;
 }
 
 /* Prevent overlapping menu/header borderlines for CSD */
 headerbar button.titlebutton, headerbar > menubar {
   box-shadow: none;
 }
 
 .titlebar {
   padding-top: 0px;
   padding-bottom: 0px;
 } -gtk-icon-shadow: none;
 }
 
 GimpSpinScale entry progress {
   background-color: @extreme-selected-color;
   border-width:     0px;
   border-radius:    3px;
 }
 
 GimpSpinScale button
 {
   border-color: @border-color;
   -gtk-icon-shadow: none;
 }
 
 /* Checkboxes */
 checkbutton, checkbutton.text-button, radiobutton, radiobutton.text-button, checkbutton label {
   color: @fg-color;
   background-color: @bg-color;
 }
 
 checkbutton:hover, checkbutton.text-button:hover, checkbutton:hover label, radiobutton:hover, checkbutton label:hover {
   color: @fg-color;
   background-color: @hover-color;
 }
 
 checkbutton check, radiobutton radio, treeview.view check {
   background-image: none;
   background-color: @extreme-bg-color;
   border: 1px solid @stronger-border-color;
 }
 
 checkbutton check:checked {
   color: @fg-color;
 }
 
 checkbutton check:disabled {
   color: @disabled-fg-color;
   background-color: @bg-color;
 }
 
 checkbutton:checked label, radiobutton:checked label {
   font-weight: bold;
 }
 
 /* Some plugins have radio buttons, e.g. Fractal Explorer */
 radio {
   background-image: none;
   background-color: @extreme-bg-color;
   border: 1px solid @stronger-border-color;
   border-radius: 100%;
   color: @fg-color;
 }
 
 /* Removes "blurred" effect from tooltip label */
 tooltip {
   background-color: @bg-color;
   background-image: none;
   border: 1px solid @edge-border-color;
   text-shadow: 0 0;
 }
 
 tooltip box
 {
   background-color: @bg-color;
   border: 0px solid @transparent;
 }
 
 /* Prevents flickering effect on some desktops */
 tooltip decoration {
   box-shadow: 0px 0px;
 }
 
 /* The border around a tooltip */
 .background {
   background-color: @bg-color;
   border-color: @border-color;
   border-width: 1px;
 }
 
 /* The border around a frame */
 border {
   border: 0.1px;
 }
 
 /* The border around GimpOffsetArea frame in resize dialogs */
 .gimp-offset-area-frame {
   border: solid 2px @stronger-border-color;
   background-color: @widget-bg-color;
 }
 
 /* For dropdown menus (e.g. "px" when creating a new image */
 #gtk-combobox-popup-menu {
   background-color: @bg-color;
   color: @fg-color;
 }
 
 /* Top menu items  */
 
 /* give the menu bar a color, fix for the default color being too dark */
 menubar {
   background-color: @bg-color;
   background-image: none;
   box-shadow: 0 -1px @edge-border-color inset;
 }
 
 menuitem:hover, menuitem:selected
 {
   border: 0px solid transparent;
 }
 
 /* The top menu item itself: File, Edit ... */
 menuitem menuitem {
   color: @fg-color;
   background: @extreme-bg-color;
 }
 
 /* A top (File, Edit) menubar item when its menu is expanded. */
 menubar > menuitem:hover {
   color: @fg-color;
   background: @extreme-bg-color;
 }
 
 /* Top menubar subitem style */
 menubar menu menuitem {
   color: @fg-color;
   background-color: @bg-color;
 }
 
 menubar menu menuitem:hover {
   color: @fg-color;
   background-color: @extreme-bg-color;
 }
 
 menuitem *:hover {
   color: @fg-color;
   background: @extreme-selected-color;
 }
 
 menuitem check {
   border-color: @fg-color;
 }
 
 menuitem decoration
 {
   box-shadow: 0 1px 2px @edge-border-color;
 }
 
 /* "Add Tab" menu in dockable dialog */
 menu {
   background-color: @bg-color;
 }
 
 /* Fixes issue with top menu label not changing
  * colors when highlighted
  */
 menu box {
   background-color: transparent;
 }
 
 /* In some cases, the GtkSeparatorMenuItem-s get very ugly top/bottom margin
  * with a different background color. Let's get rid of it.
  */
 menu separator {
   background-color: @stronger-border-color;
   margin: 0;
 }
 
 /* Defines the border around the Save Image actionbar options */
 actionbar revealer box {
   border-width: 0px;
   border-top-width: 1px;
   border-top-color: @strong-border-color;
 }
 
 /* Sidebar in File > Open */
 
 /* The background to either side of the directory buttons.
  * The color of the buttons themselves comes from somewhere else.
  */
 .sidebar-row, .sidebar-row * {
   background-color: @widget-bg-color;
 }
 
 .sidebar-row:selected, .sidebar-row:selected * {
   background-color: @selected-color;
 }
 
 .sidebar-row:hover, .sidebar-row:hover * {
   background-color: @bg-color;
 }
 
 /* GtkListBox widgets */
 
 list, list row {
   background-color: @widget-bg-color;
 }
 
 list row:selected {
   background-color: @selected-color;
 }
 
 list row:hover {
   background-color: @hover-color;
 }
 
 /* GtkSwitch buttons */
 
 switch {
   background-color: @bg-color;
   border: 1px solid @stronger-border-color;
 }
 
 /* The switch button is hard to understand without color.
  * Let's indicate the checked state with foreground color.
  */
 switch:checked {
   background-color: @fg-color;
 }
 
 /* This prevents the 1/0 labels from appearing inside the switch slider */
 switch image {
   color: transparent;
 }
 
 headerbar {
   min-height: 36px;
   background-color: @bg-color;
   background-image: none;
   border-color: @sap;
   outline-color: @sap;
   box-shadow: none;
   border-radius: 10px;
 }
 
 headerbar:backdrop * {
   color: @disabled-fg-color;
 }
 
 /* Prevent overlapping menu/header borderlines for CSD */
 headerbar button.titlebutton, headerbar > menubar {
   box-shadow: none;
 }
 
 .titlebar {
   padding-top: 0px;
   padding-bottom: 0px;
 }
}    
]]
  end
  if utils.write_to_file(gimp_css_path, gimp_css_content) then
    vim.notify("GIMP theme updated to " .. theme, vim.log.levels.INFO)
  else
    utils.log("Failed to write GIMP CSS to " .. gimp_css_path, vim.log.levels.ERROR, false)
    vim.notify("Failed to write GIMP CSS to " .. gimp_css_path, vim.log.levels.ERROR)
  end
end

return M
