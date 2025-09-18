local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = colors.bg -- Theme background (e.g., #1C1B1A dark, #FFFFFF light)
  local foreground = colors.fg -- Theme foreground (e.g., #F4E3C1 dark, #1C1B1A light)
  local border_color = "#9280E8" -- Consistent border/accent color
  local tooltip_background = theme_name == "dark" and background or foreground -- Swap for tooltip

  return string.format(
    [[
    /* General Waybar Styling */
* {
  border: none;
  font-family: 'Hurmit Nerd Font';
  font-size: 18px;
  min-height: 20px;
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
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#custom-arch:hover, #workspaces:hover {
  border: 2px solid %s;
  background: %s;
}

/* Workspace Buttons */
#workspaces button {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#workspaces button:hover, #workspaces button.active {
  border: 2px solid %s;
  background: %s;
}

/* Center Section */
#custom-weather, #custom-hyprclock, #wlr-taskbar {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#custom-weather:hover, #custom-hyprclock:hover, #wlr-taskbar:hover {
  border: 2px solid %s;
  background: %s;
}

/* Weather Popup Styling */
#custom-weather > tooltip {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  border: 2px solid %s;
  background: %s;
}

/* Taskbar Buttons */
#wlr-taskbar button {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
  outline: none; /* Remove focus outline */
}

#wlr-taskbar button:hover {
  border: 2px solid %s;
  background: %s;
}

/* Right Section */
#custom-spotify, #pulseaudio, #network, #custom-cpu-usage, #custom-gpu-usage, #custom-disk-usage {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  background: transparent;
}

#custom-spotify:hover, #pulseaudio:hover, #network:hover, #custom-cpu-usage:hover, #custom-gpu-usage:hover, #custom-disk-usage:hover {
  border: 2px solid %s;
  background: %s;
}

/* Pulseaudio Active State */
#pulseaudio:active {
  border: 2px solid %s;
  background: transparent;
}
]],
    foreground, -- 1: General text color
    background, -- 2: Waybar background
    border_color, -- 3: Left section hover border
    border_color, -- 4: Left section hover background
    border_color, -- 5: Workspace button hover/active border
    border_color, -- 6: Workspace button hover/active background
    border_color, -- 7: Center section hover border
    border_color, -- 8: Center section hover background
    border_color, -- 9: Tooltip border
    tooltip_background, -- 10: Tooltip background
    border_color, -- 11: Taskbar button hover border
    border_color, -- 12: Taskbar button hover background
    border_color, -- 13: Right section hover border
    border_color, -- 14: Right section hover background
    border_color -- 15: Pulseaudio active border
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
    --os.execute("pkill -SIGUSR2 waybar 2>/dev/null || waybar & disown") -- Reload or restart Waybar
  else
    utils.log("Failed to write Waybar CSS to " .. css_path, vim.log.levels.ERROR, false)
  end
end

return M
