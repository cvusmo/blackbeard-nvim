-- ~/blackbeard-nvim/lua/blackbeard/utils.lua

local M = {}

-- State file to store the current theme
local state_file = vim.fn.expand("~/.cache/blackbeard-nvim/current-theme")

-- Ensure the state directory exists
local function ensure_state_dir()
  local state_dir = vim.fn.expand("~/.cache/blackbeard-nvim")
  if vim.fn.isdirectory(state_dir) == 0 then
    vim.fn.mkdir(state_dir, "p")
  end
end

-- Read the current theme from the state file
function M.get_stored_theme()
  ensure_state_dir()
  local file = io.open(state_file, "r")
  if file then
    local theme = file:read("*line")
    file:close()
    return theme
  end
  return nil
end

-- Write the current theme to the state file
function M.store_theme(theme)
  ensure_state_dir()
  local file = io.open(state_file, "w")
  if file then
    file:write(theme)
    file:close()
  else
    M.log("Failed to write theme to state file: " .. state_file, vim.log.levels.ERROR, false)
  end
end

-- Improved logging function
function M.log(message, level, is_user_command)
  level = level or vim.log.levels.INFO
  is_user_command = is_user_command or false

  -- Only show notifications for ERRORs or user command results (INFO level)
  if level == vim.log.levels.ERROR or (is_user_command and level == vim.log.levels.INFO) then
    vim.notify(message, level)
  end

  -- Always log to a file for debugging
  local log_file = vim.fn.expand("~/.cache/blackbeard-nvim/log")
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local level_str = vim.log.levels[level] or "INFO"
  local log_message = string.format("[%s] [%s] %s\n", timestamp, level_str, message)
  local file = io.open(log_file, "a")
  if file then
    file:write(log_message)
    file:close()
  end
end

-- Helper to write content to a file
function M.write_to_file(filepath, content)
  local file = io.open(filepath, "w")
  if not file then
    M.log("Error opening file: " .. filepath, vim.log.levels.ERROR, false)
    return false
  end
  file:write(content)
  file:close()
  return true
end

-- Helper to handle transparency in the theme
function M.handle_transparency(is_transparent)
  if is_transparent then
    vim.cmd("hi Normal guibg=NONE")
  end
end

-- Function to merge user colors with the default palette
function M.merge_colors(palette, custom_colors)
  return vim.tbl_deep_extend("force", palette, custom_colors or {})
end

-- Apply Neovim highlights using vim.api.nvim_set_hl to avoid notification noise
function M.apply_highlights(theme_colors)
  for group, settings in pairs(theme_colors) do
    local hl_opts = {}
    if settings.fg then
      hl_opts.fg = settings.fg
    end
    if settings.bg then
      hl_opts.bg = settings.bg
    end
    if settings.italic then
      hl_opts.italic = true
    end
    if settings.bold then
      hl_opts.bold = true
    end
    -- Use vim.api.nvim_set_hl instead of vim.cmd
    vim.api.nvim_set_hl(0, group, hl_opts)
  end
end

-- Update icon theme for GTK
function M.update_icon_theme(icon_theme, current_theme)
  local home = os.getenv("HOME")
  local gtk3_config = home .. "/.config/gtk-3.0/settings.ini"
  local gtk4_config = home .. "/.config/gtk-4.0/settings.ini"
  local gtk2_config = home .. "/.gtkrc-2.0"

  local gtk34_content = string.format(
    "[Settings]\n" .. "gtk-theme-name=%s\n" .. "gtk-icon-theme-name=%s\n" .. "gtk-cursor-theme-name=Adwaita\n",
    current_theme == "dark" and "blackbeard-dark" or "blackbeard-light",
    icon_theme
  )

  vim.fn.mkdir(home .. "/.config/gtk-3.0", "p")
  if not M.write_to_file(gtk3_config, gtk34_content) then
    M.log("Failed to write GTK 3.0 config.", vim.log.levels.ERROR, false)
  end

  vim.fn.mkdir(home .. "/.config/gtk-4.0", "p")
  if not M.write_to_file(gtk4_config, gtk34_content) then
    M.log("Failed to write GTK 4.0 config.", vim.log.levels.ERROR, false)
  end

  local gtk2_content = string.format(
    'gtk-theme-name="%s"\n' .. 'gtk-icon-theme-name="%s"\n' .. 'gtk-cursor-theme-name="Adwaita"\n',
    current_theme == "dark" and "blackbeard-dark" or "blackbeard-light",
    icon_theme
  )
  if not M.write_to_file(gtk2_config, gtk2_content) then
    M.log("Failed to write GTK 2.0 config.", vim.log.levels.ERROR, false)
  end

  local gsettings_cmd = string.format("gsettings set org.gnome.desktop.interface icon-theme '%s'", icon_theme)
  local success = os.execute(gsettings_cmd)
  if not success then
    M.log("Failed to apply icon theme via gsettings.", vim.log.levels.WARN, false)
  end
end

return M
