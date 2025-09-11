local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = theme_name == "dark" and colors.bg or colors.fg -- Dark bg or Light fg
  local foreground = theme_name == "light" and colors.fg or colors.bg -- Light fg or Dark bg (corrected)
  local border_color = "#9280E8"
  local opacity = theme_name == "dark" and "0.93" or "1" -- Slightly transparent for dark, solid for light

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
  border: 2px solid %s;
  border-radius: 5px;
  min-width: 30px;
}

#workspaces button:hover {
  background: %s;
}

#workspaces button.active {
  background: %s;
  color: %s;
  border: 2px solid %s;
}

/* Center Section */
#custom-weather, #custom-hyprclock, #wlr-taskbar {
  border-radius: 10px;
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#custom-weather:hover, #custom-hyprclock:hover, #wlr-taskbar:hover {
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
  background: %s;
  border: 2px solid %s;
  border-radius: 5px;
}

#wlr-taskbar button:hover {
  background: %s;
}

/* Right Section */
#custom-spotify, #pulseaudio, #network, #custom-cpu-usage, #custom-gpu-usage, #custom-disk-usage {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#custom-spotify:hover, #pulseaudio:hover, #network:hover, #custom-cpu-usage:hover, #custom-gpu-usage:hover, #custom-disk-usage:hover {
  background: %s;
}

/* Hypothetical New Section for #pulseaudio (example) */
#pulseaudio:hover {
  background: %s; -- Argument 30
}
#pulseaudio:active {
  background: %s; -- Argument 31
}
]],
    foreground, -- 1
    background, -- 2
    opacity, -- 3
    border_color, -- 4
    background, -- 5
    border_color, -- 6
    foreground, -- 7
    border_color, -- 8
    border_color, -- 9
    background, -- 10
    foreground, -- 11
    border_color, -- 12
    foreground, -- 13
    opacity, -- 14
    border_color, -- 15
    background, -- 16
    border_color, -- 17
    background, -- 18
    foreground, -- 19
    border_color, -- 20
    foreground, -- 21
    border_color, -- 22
    border_color, -- 23
    opacity, -- 24
    border_color, -- 25
    background, -- 26
    border_color, -- 27
    border_color, -- 28 (custom-spotify hover, to be replaced)
    border_color, -- 29 (custom-spotify active, to be replaced)
    border_color, -- 30 (#pulseaudio hover)
    border_color -- 31 (#pulseaudio active)
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
    os.execute("pkill -SIGUSR2 waybar") -- Reload Waybar
  else
    utils.log("Failed to write Waybar CSS to " .. css_path, vim.log.levels.ERROR, false)
  end
end

return M
