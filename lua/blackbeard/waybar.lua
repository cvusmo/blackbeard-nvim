-- ~/blackbeard-nvim/lua/blackbeard/waybar.lua

local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background, foreground, hover_color
  if theme_name == "dark" then
    background = colors.bg -- #1C1B1A
    foreground = colors.fg -- #F4E3C1
    hover_color = colors.green -- #73A857
  else -- light
    background = colors.white -- #6A5E47
    foreground = colors.fg -- #1C1B1A
    hover_color = colors.yellow -- #A67F20
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
  border: none;
  background: %s;
}

/* Apply hover effect only to custom-arch (single element) */
#custom-arch:hover {
  background-color: rgba(%s, 0.2);
  border: 1px solid %s;
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
  background-color: rgba(%s, 0.2);
  border: 1px solid %s;
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
  border: none;
  background: %s;
}

#clock {
  font-weight: bold;
  font-size: 18px;
}

/* Apply hover effect to single-element modules */
#custom-playerctl:hover, #custom-spotify:hover, #clock:hover {
  background-color: rgba(%s, 0.2);
  border: 1px solid %s;
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
  background-color: rgba(%s, 0.2);
  border: 1px solid %s;
}

/* Right Section */
#pulseaudio, #network, #custom-diskusage, #custom-volume_control {
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  opacity: 0.93;
  border: none;
  background: %s;
}

/* Apply hover effect to single-element modules */
#pulseaudio:hover, #network:hover, #custom-diskusage:hover, #custom-volume_control:hover {
  background-color: rgba(%s, 0.2);
  border: 1px solid %s;
}

/* Notifications */
#custom-notifications {
  border-radius: 5px;
  color: %s;
  padding-right: 5px;
  border: none;
  background: %s;
}

#custom-notifications:hover {
  background-color: rgba(%s, 0.2);
  border: 1px solid %s;
}
]],
    foreground,
    background, -- General
    background,
    hover_color,
    hover_color, -- custom-arch
    foreground,
    background,
    hover_color,
    hover_color, -- workspaces
    background,
    foreground, -- workspaces active
    foreground,
    background,
    hover_color,
    hover_color, -- center section
    foreground,
    background,
    hover_color,
    hover_color, -- taskbar
    background,
    hover_color,
    hover_color, -- right section
    foreground,
    background,
    hover_color,
    hover_color -- notifications
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
