-- ~/blackbeard-nvim/lua/blackbeard/dmenu.lua

local M = {}
local utils = require("blackbeard.utils")

-- Store the last applied theme to avoid redundant updates
local last_theme = nil

function M.update_theme(theme_name)
  if last_theme == theme_name then
    utils.log("dmenu theme " .. theme_name .. " is already applied, skipping update.", vim.log.levels.DEBUG, false)
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

  -- Generate dmenu command with theme colors
  local dmenu_cmd
  if theme_name == "dark" then
    dmenu_cmd = string.format(
      "dmenu -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
      colors.bg, -- #1C1B1A (dark background)
      colors.fg, -- #F4E3C1 (cream white)
      colors.selection_bg, -- #F4A259 (orange)
      colors.selection_fg -- #1C1B1A (dark gray)
    )
  else -- light
    dmenu_cmd = string.format(
      "dmenu -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
      colors.white, -- #6A5E47 (darker brown)
      colors.fg, -- #1C1B1A (dark gray)
      colors.selection_bg, -- #F4A259 (orange)
      colors.bg -- #F4E3C1 (cream white)
    )
  end

  -- Write the dmenu command to a script file for easy use
  local script_path = vim.fn.expand("~/.config/blackbeard-nvim/dmenu-run")
  local script_content = string.format("#!/bin/sh\n%s_run", dmenu_cmd)
  if utils.write_to_file(script_path, script_content) then
    -- Make the script executable
    os.execute("chmod +x " .. script_path)
    utils.log("dmenu theme updated to " .. theme_name .. " at: " .. script_path, vim.log.levels.INFO, false)
  end
end

return M
