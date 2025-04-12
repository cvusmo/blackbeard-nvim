-- ~/blackbeard-nvim/lua/blackbeard/hyprland.lua

local M = {}
local utils = require("blackbeard.utils")

-- Path to Hyprland's env.conf
local env_conf_path = vim.fn.expand("~/.config/hypr/configs/env.conf")

-- Default cursor settings (can be made configurable if needed)
local cursor_theme = "Nordzy-cursors"
local cursor_size = 24

-- Function to read the env.conf file and return its lines
local function read_env_conf()
  local file = io.open(env_conf_path, "r")
  if not file then
    utils.log("Failed to read Hyprland env.conf at: " .. env_conf_path, vim.log.levels.ERROR, false)
    return nil
  end
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

-- Function to update the theme-related settings in env.conf
function M.update_theme(theme)
  local lines = read_env_conf()
  if not lines then
    return
  end

  -- Theme settings to update
  local gtk_theme = theme == "dark" and "blackbeard-dark" or "blackbeard-light"
  local theme_settings = {
    ["env = GTK_THEME"] = string.format("env = GTK_THEME, %s", gtk_theme),
    ["env = XCURSOR_THEME"] = string.format("env = XCURSOR_THEME, %s", cursor_theme),
    ["env = XCURSOR_SIZE"] = string.format("env = XCURSOR_SIZE, %d", cursor_size),
    ["env = HYPRCURSOR_THEME"] = string.format("env = HYPRCURSOR_THEME, %s-hyprcursor", cursor_theme),
    ["env = HYPRCURSOR_SIZE"] = string.format("env = HYPRCURSOR_SIZE, %d", cursor_size),
  }

  -- Flag to track if we're in the "Themes" section
  local in_themes_section = false
  local updated_lines = {}
  local themes_section_found = false

  for _, line in ipairs(lines) do
    -- Check if we're entering the "Themes" section
    if line:match("^#### Themes") then
      in_themes_section = true
      themes_section_found = true
      table.insert(updated_lines, line)
    -- Check if we're leaving the "Themes" section
    elseif line:match("^####") and in_themes_section then
      in_themes_section = false
      table.insert(updated_lines, line)
    -- If we're in the "Themes" section, update the relevant settings
    elseif in_themes_section then
      local key = line:match("^(env = [%w_]+)")
      if key and theme_settings[key] then
        table.insert(updated_lines, theme_settings[key])
        theme_settings[key] = nil -- Mark this setting as updated
      elseif line:match("^#") or line:match("^%s*$") then
        -- Preserve comments and empty lines in the Themes section
        table.insert(updated_lines, line)
      end
    else
      -- Preserve all other lines (outside the Themes section)
      table.insert(updated_lines, line)
    end
  end

  -- If there are any theme settings that weren't updated (e.g., they weren't in the file), append them
  if themes_section_found and in_themes_section == false then
    for _, setting in pairs(theme_settings) do
      if setting then
        table.insert(updated_lines, setting)
      end
    end
  end

  -- Write the updated content back to env.conf
  if not utils.write_to_file(env_conf_path, table.concat(updated_lines, "\n") .. "\n") then
    utils.log("Failed to update Hyprland env.conf", vim.log.levels.ERROR, false)
    return
  end

  -- Reload Hyprland to apply the changes
  local success = os.execute("hyprpm reload >/dev/null 2>&1")
  if success then
    utils.log("Hyprland env.conf updated and reloaded successfully.", vim.log.levels.INFO, false)
  else
    utils.log("Failed to reload Hyprland after updating env.conf.", vim.log.levels.WARN, false)
  end
end

return M
