local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = colors.bg
  local foreground = colors.fg
  local border_color = "#9280E8" -- Consistent border color from original CSS
  local opacity = theme_name == "dark" and 0.93 or 1.0 -- Numeric opacity for dark/light themes
  local accent_border = theme_name == "dark" and colors.bg or colors.fg -- Dark contrast for right-section border (matches original #1C1B1A in dark; dark fg in light for contrast on purple)

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
  background: %s;
}

#workspaces button.active {
  background: %s;
  color: %s;
  border: none;
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
  background: transparent;
}

#custom-spotify:hover, #pulseaudio:hover, #network:hover, #custom-cpu-usage:hover, #custom-gpu-usage:hover, #custom-disk-usage:hover {
  background: %s;
}

/* Hypothetical New Section for #pulseaudio (example) */
#pulseaudio:hover {
  background: %s;
}
#pulseaudio:active {
  background: %s;
}
]],
    foreground, -- 1: General color
    background, -- 2: #waybar background
    opacity, -- 3: Left section opacity
    border_color, -- 4: Left section border
    background, -- 5: Left section background
    border_color, -- 6: Left section hover background
    foreground, -- 7: Workspace button color
    border_color, -- 8: Workspace button border
    border_color, -- 9: Workspace button hover background
    background, -- 10: Workspace button active background
    foreground, -- 11: Workspace button active color
    border_color, -- 12: Workspace button active border
    foreground, -- 13: Center section color
    opacity, -- 14: Center section opacity
    border_color, -- 15: Center section border
    background, -- 16: Center section background
    border_color, -- 17: Center section hover background
    background, -- 18: Tooltip background
    foreground, -- 19: Tooltip color
    border_color, -- 20: Tooltip border
    foreground, -- 21: Taskbar button color
    border_color, -- 22: Taskbar button background
    border_color, -- 23: Taskbar button border
    border_color, -- 24: Taskbar button hover background
    opacity, -- 25: Right section opacity
    accent_border, -- 26: Right section border (dark contrast)
    border_color, -- 27: Right section background
    border_color, -- 28: Right section hover background
    border_color, -- 29: Pulseaudio hover background
    border_color -- 30: Pulseaudio active background
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
