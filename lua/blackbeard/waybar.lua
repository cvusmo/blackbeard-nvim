local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = colors.bg
  local foreground = colors.fg
  local border_color = "#9280E8" -- For hover/active backgrounds
  local module_border_color = theme_name == "dark" and colors.fg or colors.fg
  local tooltip_foreground = theme_name == "dark" and colors.fg or colors.brwhite
  local tooltip_background = theme_name == "dark" and background or foreground
  local hover_foreground = theme_name == "dark" and colors.brwhite or colors.brwhite

  return string.format(
    [[
/* General Waybar Styling */
* {
  border: none;
  font-family: 'Hurmit Nerd Font';
  font-size: 18px;
  min-height: 24px;
  color: %s;
  background: transparent;
}

#waybar {
  background-color: %s;
  border-radius: 10px;
  padding: 5px;
}

/* Left Section */
#custom-arch, #workspaces {
  color: %s;
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#custom-arch:hover {
  color: #F6E8CD;
  border: 1px solid %s;
  background: %s;
}

/* Workspace Buttons */
#workspaces button {
  color: %s;
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#workspaces button:hover {
  color: #F6E8CD;
  border: 1px solid %s;
  background: %s;
}

#workspaces button.active {
  color: #F6E8CD;
  border: 1px solid %s;
  background: %s;
}

/* Center Section */
#custom-stocks, #custom-weather, #custom-hyprclock {
  color: %s;
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent; 
}

#custom-weather:hover, #custom-hyprclock:hover {
  color: %s;
  border: 2px solid %s;
  background: %s;
}

#custom-stocks:hover {
  color: %s;
  border: 2px solid %s;
}

/* Tooltip Styling */
tooltip {
  background: %s;
  border: 2px solid %s;
  border-radius: 10px;
  color: %s;
  padding: 5px 10px;
}

tooltip.stocks,
tooltip.weather {
  background: %s;
  border: 2px solid %s;
  border-radius: 10px;
  color: %s;
  padding: 5px 10px;
}

/* Right Section */
#custom-spotify, #pulseaudio, #network, #custom-cpu-usage, #custom-gpu-usage, #custom-disk-usage {
  color: %s;
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#custom-spotify:hover, #pulseaudio:hover, #network:hover, #custom-cpu-usage:hover, #custom-gpu-usage:hover, #custom-disk-usage:hover {
  color: #F6E8CD;
  border: 2px solid %s;
  background: %s;
}

/* Pulseaudio Active State */
#pulseaudio:active {
  color: #F6E8CD;
  border: 2px solid %s;
  background: %s;
}
    ]],
    foreground, -- * { color }
    background, -- #waybar bg
    foreground, -- #custom-arch, #workspaces color
    foreground,
    border_color, -- arch hover
    foreground,
    foreground,
    border_color, -- workspace buttons
    foreground,
    border_color,
    border_color, -- workspace active
    foreground, -- center section color
    foreground,
    border_color,
    border_color, -- hover weather/clock
    foreground,
    border_color, -- hover stocks
    tooltip_background,
    border_color,
    tooltip_foreground, -- tooltip base
    tooltip_background,
    border_color,
    tooltip_foreground, -- tooltip stocks/weather
    foreground,
    border_color,
    border_color, -- right section hover
    border_color,
    border_color -- pulseaudio active
  )
end

function M.update_theme(theme_name, force)
  utils.log(
    "update_theme called with theme: " .. theme_name .. ", force: " .. tostring(force),
    vim.log.levels.DEBUG,
    false
  )
  if last_theme == theme_name and not force then
    utils.log("Waybar theme " .. theme_name .. " is already applied, skipping update.", vim.log.levels.DEBUG, false)
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

  local css = generate_waybar_css(colors, theme_name)

  -- Write the CSS to file (so Waybar can reload it)
  local css_file = os.getenv("HOME") .. "/.config/waybar/blackbeard.css"
  local f = io.open(css_file, "w")
  if f then
    f:write(css)
    f:close()
    utils.log("Waybar CSS written to " .. css_file, vim.log.levels.DEBUG, false)
  else
    utils.log("Failed to open Waybar CSS file for writing", vim.log.levels.ERROR, false)
  end

  last_theme = theme_name
end

return M
