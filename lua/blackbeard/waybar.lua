local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = colors.bg
  local foreground = colors.fg
  local border_color = "#9280E8"
  local opacity = theme_name == "dark" and "0.93" or "1"

  return string.format(
    [[
/* General Waybar Styling */
* {
  border: none;
  font-family: 'Hurmit Nerd Font';
  font-size: 18px;
  min-height: 30px;
  color: %s;
}

#waybar {
  background-color: %s;
  border-radius: 10px;
  padding: 5px;
}

/* Left Section */
#custom-arch, #workspaces {
  border-radius: 10px;
  margin-top: 5px;
  margin-left: 5px;
  padding: 5px 10px;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#custom-arch:hover, #workspaces:hover {
  background: %s;
}

/* Workspace Buttons */
#workspaces button {
  padding: 0 10px;
  margin: 0 5px;
  color: %s;
  background: transparent;
  border: none;
  border-radius: 5px;
  min-width: 30px;
}

#workspaces button:hover {
  background: transparent;
}

#workspaces button.active {
  background: %s;
  color: %s;
  border: none;
}

/* Center Section */
#custom-playerctl, #custom-spotify, #custom-weather, #custom-hyprclock, #wlr-taskbar {
  border-radius: 10px;
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#custom-playerctl:hover, #custom-spotify:hover, #custom-weather:hover, #custom-hyprclock:hover, #wlr-taskbar:hover {
  background: %s;
}

/* Weather Popup Styling */
#custom-weather > tooltip {
  background-color: %s;
  color: %s;
  border: 1px solid %s;
  border-radius: 8px;
  padding: 10px;
  font-family: 'Hurmit Nerd Font';
  font-size: 14px;
}

/* Taskbar Buttons */
#wlr-taskbar button {
  padding: 0 5px;
  margin: 0 5px;
  color: %s;
  background: transparent;
  border: none;
  border-radius: 5px;
}

#wlr-taskbar button:hover {
  background: transparent;
}

/* Right Section */
#pulseaudio, #network, #custom-cpu-usage, #custom-gpu-usage, #custom-disk-usage, #custom-volume_control {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#pulseaudio:hover, #network:hover, #custom-cpu-usage:hover, #custom-gpu-usage:hover, #custom-disk-usage:hover, #custom-volume_control:hover {
  background: %s;
}
]],
    foreground,
    background, -- General
    opacity, -- Left section opacity
    border_color, -- Left section border
    background, -- Left section background
    border_color, -- Left section hover background
    foreground, -- Workspace button text
    background, -- Workspace button active background
    foreground, -- Workspace button active text
    foreground, -- Center section text
    opacity, -- Center section opacity
    border_color, -- Center section border
    background, -- Center section background
    border_color, -- Center section hover background
    background, -- Weather popup background
    foreground, -- Weather popup text color
    border_color, -- Weather popup border
    foreground, -- Taskbar button text
    opacity, -- Right section opacity
    border_color, -- Right section border
    background, -- Right section background
    border_color -- Right section hover background
  )
end

function M.update_theme(theme_name, force)
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

  last_theme = theme_name
  local css_content = generate_waybar_css(colors, theme_name)
  local css_path = vim.fn.expand("~/.config/waybar/style.css")
  if utils.write_to_file(css_path, css_content) then
    utils.log("Waybar theme updated to " .. theme_name .. " at: " .. css_path, vim.log.levels.INFO, false)
    os.execute("pkill -SIGUSR2 waybar")
  else
    utils.log("Failed to write Waybar CSS to " .. css_path, vim.log.levels.ERROR, false)
  end
end

return M
