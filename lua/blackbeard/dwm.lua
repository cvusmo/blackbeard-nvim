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
  -- Map colors to match the structure of blackbearddark.h and blackbeardlight.h
  local mapped_colors = {
    black = theme_name == "dark" and colors.bg or colors.fg, -- Background (dark) or Foreground (light)
    white = theme_name == "dark" and colors.fg or colors.bg, -- Foreground (dark) or Background (light)
    gray2 = theme_name == "dark" and colors.black or colors.white, -- Unfocused window border
    gray3 = colors.brblack, -- Bright black
    gray4 = theme_name == "dark" and colors.white or colors.black, -- Normal white (dark) or black (light)
    blue = colors.blue, -- Focused window border
    green = colors.green,
    red = colors.red,
    orange = colors.selection_bg, -- Selection background
    yellow = colors.yellow,
    pink = colors.magenta,
    col_borderbar = theme_name == "dark" and colors.bg or colors.bg, -- Inner border (matches background)
  }

  return string.format(
    [[/* blackbeard%s.h */
static const char black[]       = "%s";  // %s
static const char white[]       = "%s";  // %s
static const char gray2[]       = "%s";  // Unfocused window border
static const char gray3[]       = "%s";  // Bright black
static const char gray4[]       = "%s";  // Normal %s
static const char blue[]        = "%s";  // Focused window border
static const char green[]       = "%s";
static const char red[]         = "%s";
static const char orange[]      = "%s";  // Selection background
static const char yellow[]      = "%s";
static const char pink[]        = "%s";
static const char col_borderbar[] = "%s"; // Inner border

/* Define the colors array for dwm */
static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = { %s,      %s,     gray2 },  // Normal: %s text, %s bg, gray2 border
    [SchemeSel]  = { %s,      orange,    blue  },  // Selected: %s text, orange bg, blue border
};
]],
    theme_name, -- File name (blackbearddark.h or blackbeardlight.h)
    mapped_colors.black,
    theme_name == "dark" and "Background" or "Foreground",
    mapped_colors.white,
    theme_name == "dark" and "Foreground" or "Background",
    mapped_colors.gray2,
    mapped_colors.gray3,
    mapped_colors.gray4,
    theme_name == "dark" and "white" or "black",
    mapped_colors.blue,
    mapped_colors.green,
    mapped_colors.red,
    mapped_colors.orange,
    mapped_colors.yellow,
    mapped_colors.pink,
    mapped_colors.col_borderbar,
    theme_name == "dark" and "white" or "black", -- SchemeNorm fg
    theme_name == "dark" and "black" or "white", -- SchemeNorm bg
    theme_name == "dark" and "white" or "black", -- SchemeNorm fg description
    theme_name == "dark" and "black" or "white", -- SchemeNorm bg description
    theme_name == "dark" and "white" or "black", -- SchemeSel fg
    theme_name == "dark" and "white" or "black" -- SchemeSel fg description
  )
end

local function update_config_h(theme_name)
  local config_path = vim.fn.expand("~/.config/dwm/config.h")
  local lines = {}
  local found_dark = false
  local found_light = false
  local themes_comment_found = false

  -- Read the current config.h
  local file = io.open(config_path, "r")
  if not file then
    vim.notify("Error reading config.h at: " .. config_path, vim.log.levels.ERROR)
    return false
  end

  for line in file:lines() do
    if line:match("/%* Themes %- Colors defined here %*/") then
      themes_comment_found = true
    end
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
    if themes_comment_found then
      for i, line in ipairs(lines) do
        if line:match("/%* Themes %- Colors defined here %*/") then
          table.insert(lines, i + 1, '#include "themes/blackbeard' .. theme_name .. '.h"')
          break
        end
      end
    else
      -- If the themes comment isn't found, append the include at the end
      table.insert(lines, '#include "themes/blackbeard' .. theme_name .. '.h"')
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
  if not write_to_file(dwm_path, content) then
    return
  end
  vim.notify("DWM theme header updated to " .. theme_name .. " at: " .. dwm_path, vim.log.levels.INFO)

  -- Update config.h to include the correct theme
  if update_config_h(theme_name) then
    vim.notify("DWM config.h updated to include blackbeard" .. theme_name .. ".h", vim.log.levels.INFO)
    -- Run shell commands to rebuild DWM
    local recompile_cmd = "cd ~/.config/dwm && make clean && sudo make install"
    local success = os.execute(recompile_cmd)
    if success then
      vim.notify("DWM recompiled successfully. Please restart DWM to apply the new theme.", vim.log.levels.INFO)
    else
      vim.notify("Failed to recompile DWM", vim.log.levels.ERROR)
    end
  else
    vim.notify("Failed to update config.h", vim.log.levels.ERROR)
  end
end

return M
