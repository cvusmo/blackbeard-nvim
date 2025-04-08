-- /cvusmo/blackbeard-nvim/lua/blackbeard/dwm.lua

local M = {}

local function write_to_file(filepath, content)
  local file = io.open(filepath, "w")
  if not file then
    vim.notify("Error opening file: " .. filepath, vim.log.levels.ERROR)
    return false
  end
  file:write(content)
  file:close()
  return true
end

local function generate_dwm_header(theme_name)
  local colors = theme_name == "dark" and require("blackbeard.dark-mode") or require("blackbeard.light-mode")
  return string.format(
    [[static const char black[]       = "%s";  // %s
static const char white[]       = "%s";  // %s
static const char gray2[]       = "%s";  // Unfocused window border
static const char gray3[]       = "%s";
static const char gray4[]       = "%s";
static const char blue[]        = "%s";  // Focused window border
static const char green[]       = "%s";
static const char red[]         = "%s";
static const char orange[]      = "%s";
static const char yellow[]      = "%s";
static const char pink[]        = "%s";
static const char col_borderbar[] = "%s";
]],
    colors.bg,
    theme_name == "dark" and "Background" or "Foreground",
    colors.fg,
    theme_name == "dark" and "Foreground" or "Background",
    theme_name == "dark" and colors.black or colors.white,
    colors.brblack,
    colors.white,
    colors.blue,
    colors.green,
    colors.red,
    colors.selection_bg,
    colors.yellow,
    colors.magenta,
    colors.bg
  )
end

local function update_config_h(theme_name)
  local config_path = vim.fn.expand("~/.config/dwm/config.h")
  local lines = {}
  local found_dark = false
  local found_light = false

  -- Read the current config.h
  local file = io.open(config_path, "r")
  if not file then
    vim.notify("Error reading config.h at: " .. config_path, vim.log.levels.ERROR)
    return false
  end

  for line in file:lines() do
    if line:match('#include "themes/blackbearddark.h"') then
      found_dark = true
      if theme_name == "light" then
        line = '#include "themes/blackbeardlight.h"'
      end
    elseif line:match('#include "themes/blackbeardlight.h"') then
      found_light = true
      if theme_name == "dark" then
        line = '#include "themes/blackbearddark.h"'
      end
    end
    table.insert(lines, line)
  end
  file:close()

  -- If neither include was found, add the appropriate one after the themes comment
  if not found_dark and not found_light then
    for i, line in ipairs(lines) do
      if line:match("/%* Themes %- Colors defined here %*/") then
        table.insert(lines, i + 1, '#include "themes/blackbeard' .. theme_name .. '.h"')
        break
      end
    end
  elseif found_dark and found_light then
    -- If both are present, keep only the desired one
    lines = {}
    file = io.open(config_path, "r")
    for line in file:lines() do
      if
        (theme_name == "dark" and line:match('#include "themes/blackbeardlight.h"'))
        or (theme_name == "light" and line:match('#include "themes/blackbearddark.h"'))
      then
        -- Skip the unwanted include
      else
        table.insert(lines, line)
      end
    end
    file:close()
  end

  -- Write the updated config.h
  return write_to_file(config_path, table.concat(lines, "\n") .. "\n")
end

function M.update_theme(theme_name)
  if theme_name ~= "dark" and theme_name ~= "light" then
    vim.notify("Invalid theme: " .. tostring(theme_name), vim.log.levels.ERROR)
    return
  end

  -- Generate the theme header
  local content = generate_dwm_header(theme_name)
  local dwm_path = vim.fn.expand("~/.config/dwm/themes/blackbeard" .. theme_name .. ".h")
  if write_to_file(dwm_path, content) then
    vim.notify("dwm theme header updated to " .. theme_name .. " at: " .. dwm_path, vim.log.levels.INFO)
  else
    return
  end

  -- Update config.h to include the correct theme
  if update_config_h(theme_name) then
    vim.notify("dwm config.h updated to include blackbeard" .. theme_name .. ".h", vim.log.levels.INFO)
    -- Optional: Run shell commands to rebuild dwm
    vim.fn.system("cd ~/.config/dwm && make && sudo make install")
  else
    vim.notify("Failed to update config.h", vim.log.levels.ERROR)
  end
end

return M
