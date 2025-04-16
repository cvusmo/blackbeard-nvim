local function generate_waybar_css(colors, theme_name)
  local background, foreground, border_left, border_center, border_right
  if theme_name == "dark" then
    background = colors.bg -- e.g., "#1C1B1A"
    foreground = colors.fg -- e.g., "#F4E3C1"
    border_left = colors.green -- e.g., "#73A857"
    border_center = colors.red -- e.g., "#D13438"
    border_right = colors.white -- e.g., "#AA9E87"
  else -- light
    background = colors.bg -- e.g., "#F4E3C1"
    foreground = colors.fg -- e.g., "#1C1B1A"
    border_left = colors.brgreen -- e.g., "#5A8C3A"
    border_center = colors.brred -- e.g., "#A71A1D"
    border_right = colors.brwhite -- e.g., "#C9B999"
  end

  -- Set opacity based on theme
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
#custom-playerctl, #custom-spotify, #custom-weather, #custom-hyprclock, #taskbar {
  border-radius: 10px;
  margin: 5px;
  padding: 5px 10px;
  color: %s;
  opacity: %s;
  border: 2px solid %s;
  background: %s;
}

#custom-playerctl:hover, #custom-spotify:hover, #custom-weather:hover, #custom-hyprclock:hover, #taskbar:hover {
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

/* Calendar Popup Styling */
#custom-hyprclock > tooltip {
  background-color: %s;
  color: %s;
  border: 1px solid %s;
  border-radius: 8px;
  padding: 10px;
  font-family: 'Hurmit Nerd Font';
  font-size: 14px;
}

/* Ensure calendar text is readable */
#custom-hyprclock > tooltip big, #custom-hyprclock > tooltip small, #custom-hyprclock > tooltip tt {
  color: %s;
}

/* Taskbar Buttons */
#taskbar button {
  padding: 0 5px;
  margin: 0 5px;
  color: %s;
  background: transparent;
  border: none;
  border-radius: 5px;
}

#taskbar button:hover {
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
    background, -- General section
    opacity, -- Left section opacity
    border_left, -- Left section border
    background, -- Left section background
    border_left, -- Left section hover background
    foreground, -- Workspace button text
    background, -- Workspace button active background
    foreground, -- Workspace button active text
    foreground, -- Center section text
    opacity, -- Center section opacity
    border_center, -- Center section border
    background, -- Center section background
    border_center, -- Center section hover background
    background, -- Weather popup background
    foreground, -- Weather popup text color
    border_center, -- Weather popup border
    background, -- Calendar popup background
    foreground, -- Calendar popup text color
    border_center, -- Calendar popup border
    foreground, -- Calendar popup text color for big/small/tt
    foreground, -- Taskbar button text
    opacity, -- Right section opacity (use the same opacity)
    border_right, -- Right section border
    background, -- Right section background
    border_right -- Right section hover background (if desired)
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
  local css_content = generate_waybar_css(colors, theme_name)
  local css_path = vim.fn.expand("~/.config/waybar/style.css")
  if utils.write_to_file(css_path, css_content) then
    utils.log("Waybar theme updated to " .. theme_name .. " at: " .. css_path, vim.log.levels.INFO, false)
    os.execute("pkill -SIGUSR2 waybar")
  end
end

return M
