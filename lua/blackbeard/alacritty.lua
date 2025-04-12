-- ~/blackbeard-nvim/lua/blackbeard/alacritty.lua

local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_alacritty_config(colors, font_size)
  return string.format(
    [[
# Alacritty Colors and Font Configuration
[terminal.shell]
program = "/bin/fish"

[window]
padding = { x = 4, y = 4 }
dynamic_padding = true
decorations = "Full"
opacity = 1.0  # Fully opaque to prevent background bleed-through
blur = false  # Disable blur to avoid compositor issues
dynamic_title = false

[scrolling]
history = 5000

[font]
size = %d  # Configurable font size
normal.family = "Hurmit Nerd Font"
bold.family = "Hurmit Nerd Font"
italic.family = "Hurmit Nerd Font"

[colors]
[colors.primary]
background = "%s"
foreground = "%s"

[colors.cursor]
text = "%s"
cursor = "%s"

[colors.selection]
text = "%s"
background = "%s"

[colors.normal]
black = "%s"
red = "%s"
green = "%s"
yellow = "%s"
blue = "%s"
magenta = "%s"
cyan = "%s"
white = "%s"

[colors.bright]
black = "%s"
red = "%s"
green = "%s"
yellow = "%s"
blue = "%s"
magenta = "%s"
cyan = "%s"
white = "%s"
]],
    font_size,
    colors.bg,
    colors.fg, -- Primary
    colors.cursor,
    colors.cursor, -- Cursor
    colors.selection_fg,
    colors.selection_bg, -- Selection
    colors.black,
    colors.red,
    colors.green,
    colors.yellow,
    colors.blue,
    colors.magenta,
    colors.cyan,
    colors.white, -- Normal
    colors.brblack,
    colors.brred,
    colors.brgreen,
    colors.bryellow,
    colors.brblue,
    colors.brmagenta,
    colors.brcyan,
    colors.brwhite -- Bright
  )
end

function M.update_theme(theme_name, font_size)
  if last_theme == theme_name then
    utils.log("Alacritty theme " .. theme_name .. " is already applied, skipping update.", vim.log.levels.DEBUG, false)
    return
  end

  local colors
  if theme_name == "dark" then
    colors = require("blackbeard.dark-mode")
  elseif theme_name == "light" then
    colors = require("blackbeard.light-mode")
  else
    utils.log("Invalid theme: " .. tostring(theme_name), vim.log.levels.ERROR, false)
    return
  end

  last_theme = theme_name

  local alacritty_path = vim.fn.expand("~/.config/alacritty/alacritty.toml")
  local content = generate_alacritty_config(colors, font_size)

  if utils.write_to_file(alacritty_path, content) then
    utils.log(
      "Alacritty theme updated to "
        .. theme_name
        .. " with font size "
        .. font_size
        .. " at: "
        .. alacritty_path
        .. ". Please restart Alacritty to apply the changes.",
      vim.log.levels.INFO,
      false
    )
  end
end

function M.update_font_size(font_size)
  if not last_theme then
    utils.log("No theme applied yet. Please set a theme first.", vim.log.levels.ERROR, false)
    return
  end

  font_size = tonumber(font_size)
  if not font_size or font_size <= 0 then
    utils.log("Invalid font size: must be a positive number.", vim.log.levels.ERROR, false)
    return
  end

  local colors
  if last_theme == "dark" then
    colors = require("blackbeard.dark-mode")
  elseif last_theme == "light" then
    colors = require("blackbeard.light-mode")
  else
    utils.log("Unknown theme state.", vim.log.levels.ERROR, false)
    return
  end

  local alacritty_path = vim.fn.expand("~/.config/alacritty/alacritty.toml")
  local content = generate_alacritty_config(colors, font_size)

  if utils.write_to_file(alacritty_path, content) then
    utils.log(
      "Alacritty font size updated to "
        .. font_size
        .. " at: "
        .. alacritty_path
        .. ". Please restart Alacritty to apply the changes.",
      vim.log.levels.INFO,
      false
    )
  end
end

return M
