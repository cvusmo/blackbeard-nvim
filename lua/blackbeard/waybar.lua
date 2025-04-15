-- ~/blackbeard-nvim/lua/blackbeard/waybar.lua
local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background, foreground, hover_color, border_left, border_center, border_right
  if theme_name == "dark" then
    background = colors.bg -- #1C1B1A
    foreground = colors.fg -- #F4E3C1
    hover_color = colors.blue -- #5A8CA5 (Blue for hover effect)
    border_left = colors.green -- #73A857 (Green for left modules)
    border_center = colors.red -- #D13438 (Red for center modules)
    border_right = colors.white -- #AA9E87 (White for right modules and notifications)
  else -- light
    background = colors.white -- #6A5E47
    foreground = colors.fg -- #1C1B1A
    hover_color = colors.blue -- #2A5A75 (Blue for hover effect)
    border_left = colors.green -- #4A7C2A (Green for left modules)
    border_center = colors.red -- #8B1A1E (Red for center modules)
    border_right = colors.white -- #6A5E47 (White for right modules and notifications)
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
  border: 2px solid %s; /* Green border for left modules */
  background: %s;
}

/* Apply hover effect only to custom-arch (single element) */
#custom-arch:hover {
  border: 2px solid %s; /* Blue hover highlight */
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

/* Apply hover effect only to individual workspace buttons */
#workspaces button:hover {
  border: 1px solid %s; /* Blue hover highlight */
}

#workspaces button.active {
  background: %s;
  color: %s;
  border: none;
}

/* Center Section */
#custom-playerctl, #custom-spotify, #clock, #taskbar {
  border-radius: 10px;
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: 0.93;
  border: 2px solid %s; /* Red border for center modules */
  background: %s;
}

#clock {
  font-weight: bold;
  font-size: 18px;
}

/* Apply hover effect to single-element modules */
#custom-playerctl:hover, #custom-spotify:hover, #clock:hover {
  border: 2px solid %s; /* Blue hover highlight */
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

#taskbar button:hover {
  border: 1px solid %s; /* Blue hover highlight */
}

/* Right Section */
#pulseaudio, #network, #custom-diskusage, #custom-volume_control {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  opacity: 0.93;
  border: 2px solid %s; /* White border for right modules */
  background: %s;
}

/* Apply hover effect to single-element modules */
#pulseaudio:hover, #network:hover, #custom-diskusage:hover, #custom-volume_control:hover {
  border: 2px solid %s; /* Blue hover highlight */
}

/* Notifications */
#custom-notifications {
  border-radius: 5px;
  color: %s;
  padding-right: 5px;
  border: 2px solid %s; /* White border for notifications */
  background: %s;
}

#custom-notifications:hover {
  border: 2px solid %s; /* Blue hover highlight */
}
]],
    foreground,
    background, -- General
    border_left, -- Left section border (green)
    background,
    hover_color, -- custom-arch hover (blue)
    foreground,
    background,
    hover_color, -- workspaces hover (blue)
    background,
    foreground, -- workspaces active
    foreground,
    border_center, -- Center section border (red)
    background,
    hover_color, -- center section hover (blue)
    foreground,
    background,
    hover_color, -- taskbar hover (blue)
    border_right, -- Right section border (white)
    background,
    hover_color, -- right section hover (blue)
    foreground,
    border_right, -- Notifications border (white)
    background,
    hover_color -- notifications hover (blue)
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
