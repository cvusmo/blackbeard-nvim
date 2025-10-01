local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

local function generate_waybar_css(colors, theme_name)
  local background = colors.bg
  local foreground = colors.fg
  local border_color = "#9280E8" -- For hover/active backgrounds
  local module_border_color = theme_name == "dark" and colors.fg or colors.fg -- #F4E3C1 (dark), #1C1B1A (light)
  local tooltip_foreground = theme_name == "dark" and colors.fg or colors.brwhite
  local tooltip_background = theme_name == "dark" and background or foreground
  local hover_foreground = theme_name == "dark" and colors.brwhite or colors.brwhite -- #F6E8CD (dark), #C9B999 (light)

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
  color: %s;
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
  color: %s;
  border: 1px solid %s;
  background: %s;
}

#workspaces button.active {
  color: %s;
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
  background: %s;
}

/* Weather Popup Styling */
#custom-stocks .tooltip, #custom-weather .tooltip {
  color: %s;
  border-radius: 10px;
  margin-top: 5px;
  margin-right: 5px;
  padding: 5px 10px;
  border: 2px solid %s;
  background: %s;
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
  color: %s;
  border: 2px solid %s;
  background: %s;
}

/* Pulseaudio Active State */
#pulseaudio:active {
  color: %s;
  border: 2px solid %s;
  background: %s;
}
]],
    foreground, -- 1: General text color
    background, -- 2: Waybar background
    foreground, -- 3: Left section text color
    hover_foreground, -- 4: Left section hover text color
    module_border_color, -- 5: Left section hover border
    border_color, -- 6: Left section hover background
    foreground, -- 7: Workspace button text color
    hover_foreground, -- 8: Workspace button hover text color
    module_border_color, -- 9: Workspace button hover border
    border_color, -- 10: Workspace button hover background
    hover_foreground, -- 11: Workspace button active text color
    module_border_color, -- 12: Workspace button active border
    border_color, -- 13: Workspace button active background
    foreground, -- 14: Center section text color
    hover_foreground, -- 15: Center section hover text color
    module_border_color, -- 16: Center section hover border
    border_color, -- 17: Center section hover background
    tooltip_foreground, -- 18: Tooltip text color
    module_border_color, -- 19: Tooltip border
    tooltip_background, -- 20: Tooltip background
    foreground, -- 21: Right section text color
    hover_foreground, -- 22: Right section hover text color
    module_border_color, -- 23: Right section hover border
    border_color, -- 24: Right section hover background
    hover_foreground, -- 25: Pulseaudio active text color
    module_border_color, -- 26: Pulseaudio active border
    border_color -- 27: Pulseaudio active background
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
  utils.log(
    "Applying Waybar theme: " .. theme_name .. ", fg=" .. colors.fg .. ", bg=" .. colors.bg,
    vim.log.levels.DEBUG,
    false
  )
  last_theme = theme_name
  --local css_path = vim.fn.expand("~/.config/waybar/style.css")
  --local css_content = generate_waybar_css(colors, theme_name)
  --if utils.write_to_file(css_path, css_content) then
  --utils.log("Waybar theme updated to " .. theme_name .. " at: " .. css_path, vim.log.levels.INFO, false)
  --os.execute("pkill -SIGUSR2 waybar 2>/dev/null || waybar & disown")
  --else
  --utils.log("Failed to write Waybar CSS to " .. css_path, vim.log.levels.ERROR, false)
  --end
end

return M
