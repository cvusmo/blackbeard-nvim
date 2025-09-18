local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = colors.bg -- Theme background (e.g., #1C1B1A dark, #FFFFFF light)
  local foreground = colors.fg -- Theme foreground (e.g., #F4E3C1 dark, #1C1B1A light)
  local border_color = "#9280E8" -- Consistent border/accent color
  local opacity = theme_name == "dark" and 0.93 or 1.0 -- Numeric opacity for dark/light themes
  local accent_border = theme_name == "dark" and colors.bg or colors.fg -- Dark contrast for borders (e.g., #1C1B1A)

  return string.format(
    [[
/* General Waybar Styling */
{
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
  /* border: 2px solid %s; */
  background: %s;
}

#custom-arch:hover, #workspaces:hover {
  background: %s;
  border: 2px solid %s;
}

/* Workspace Buttons */
#workspaces button {
  border-radius: 10px;
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#workspaces button.active {
  background: %s;
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

#workspaces button:hover, #custom-weather:hover, #custom-hyprclock:hover, #wlr-taskbar:hover {
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
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
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
    border_color, -- 8: Workspace button hover background
    border_color, -- 9: Workspace button active background
    foreground, -- 10: Workspace button active color (matches non-active for contrast)
    foreground, -- 11: Center section color
    opacity, -- 12: Center section opacity
    accent_border, -- 13: Center section border (dark contrast)
    background, -- 14: Center section background
    border_color, -- 15: Center section hover background
    background, -- 16: Tooltip background
    foreground, -- 17: Tooltip color
    border_color, -- 18: Tooltip border
    foreground, -- 19: Taskbar button color
    border_color, -- 20: Taskbar button background
    accent_border, -- 21: Taskbar button border
    border_color, -- 22: Taskbar button hover background
    opacity, -- 23: Right section opacity
    accent_border, -- 24: Right section border
    border_color, -- 25: Right section hover background
    accent_border, -- 26: Pulseaudio hover background
    border_color -- 27: Pulseaudio active background
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
  local css_path = vim.fn.expand("~/.config/waybar/style.css")
  local css_content = generate_waybar_css(colors, theme_name)
  if utils.write_to_file(css_path, css_content) then
    utils.log("Waybar theme updated to " .. theme_name .. " at: " .. css_path, vim.log.levels.INFO, false)
    os.execute("pkill -SIGUSR2 waybar 2>/dev/null || waybar & disown") -- Reload or restart Waybar
  else
    utils.log("Failed to write Waybar CSS to " .. css_path, vim.log.levels.ERROR, false)
  end
end

return M
