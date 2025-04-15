-- ~/blackbeard-nvim/lua/blackbeard/waybar.lua
local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background, foreground, border_left, border_center, border_right
  if theme_name == "dark" then
    background = colors.bg -- #1C1B1A
    foreground = colors.fg -- #F4E3C1
    border_left = colors.green -- #73A857 (Green for left modules)
    border_center = colors.red -- #D13438 (Red for center modules)
    border_right = colors.white -- #AA9E87 (White for right modules)
  else -- light
    background = colors.white -- #6A5E47
    foreground = colors.fg -- #1C1B1A
    border_left = colors.brgreen -- #5A8C3A (Brighter green for left modules)
    border_center = colors.brred -- #A71A1D (Brighter red for center modules)
    border_right = colors.brwhite -- #C9B999 (Brighter white for right modules)
  end

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
  opacity: 0.93;
  border: 2px solid %s; /* Static border for left modules (green in dark, brighter green in light) */
  background: %s;
}

/* Section-level hover effect for left modules */
#custom-arch:hover, #workspaces:hover {
  background: %s; /* Green background on hover for the left section */
}

/* Style for individual workspace buttons */
#workspaces button {
  padding: 0 10px;
  margin: 0 5px;
  color: %s;
  background: %s;
  border: none;
  border-radius: 5px;
  min-width: 30px;
}

/* No hover border for individual workspace buttons, background change only */
#workspaces button:hover {
  background: %s; /* Keep background change on hover, no border change */
}

#workspaces button.active {
  background: %s;
  color: %s;
  border: none;
}

/* Center Section */
#custom-playerctl, #custom-spotify, #custom-weather, #clock, #taskbar {
  border-radius: 10px;
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: 0.93;
  border: 2px solid %s; /* Static border for center modules (red in dark, brighter red in light) */
  background: %s;
}

/* Section-level hover effect for center modules */
#custom-playerctl:hover, #custom-spotify:hover, #custom-weather:hover, #clock:hover, #taskbar:hover {
  background: %s; /* Red background on hover for the center section */
}

/* Taskbar (wlr/taskbar) has individual buttons */
#taskbar button {
  padding: 0 5px;
  margin: 0 5px;
  color: %s;
  background: %s;
  border: none;
  border-radius: 5px;
}

/* No hover border for individual taskbar buttons, background change only */
#taskbar button:hover {
  background: %s; /* Keep background change on hover, no border change */
}

/* Right Section */
#pulseaudio, #network, #custom-cpu-usage, #custom-gpu-usage, #custom-disk-usage, #custom-volume_control {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  opacity: 0.93;
  border: 2px solid %s; /* Static border for right modules (white in dark, brighter white in light) */
  background: %s;
}

/* Section-level hover effect for right modules */
#pulseaudio:hover, #network:hover, #custom-cpu-usage:hover, #custom-gpu-usage:hover, #custom-disk-usage:hover, #custom-volume_control:hover {
  background: %s; /* White background on hover for the right section */
}
]],
    foreground,
    background, -- General
    border_left, -- Left section static border (green in dark, brighter green in light)
    background,
    border_left, -- Left section hover background (green in dark, brighter green in light)
    foreground,
    background,
    background, -- Workspaces button hover (no border change)
    background,
    foreground, -- Workspaces active
    foreground,
    border_center, -- Center section static border (red in dark, brighter red in light)
    background,
    border_center, -- Center section hover background (red in dark, brighter red in light)
    foreground,
    background,
    background, -- Taskbar button hover (no border change)
    border_right, -- Right section static border (white in dark, brighter white in light)
    background,
    border_right -- Right section hover background (white in dark, brighter white in light)
  )
end

function M.update_theme(theme_name)
  if last_theme == theme_name then
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

  -- Generate Waybar CSS with theme colors
  local css_content = generate_waybar_css(colors, theme_name)
  local css_path = vim.fn.expand("~/.config/waybar/style.css")
  if utils.write_to_file(css_path, css_content) then
    utils.log("Waybar theme updated to " .. theme_name .. " at: " .. css_path, vim.log.levels.INFO, false)
    -- Reload Waybar to apply the changes
    os.execute("pkill -SIGUSR2 waybar")
  end
end

return M
