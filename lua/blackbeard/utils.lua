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

-- Get the current theme from the config
function M.get_current_theme(config)
  return config.theme
end

-- Toggle between dark and light themes
function M.toggle_theme(current_theme, load_function)
  local new_theme = current_theme == "dark" and "light" or "dark"
  load_function(new_theme)
  M.log("Toggled theme to " .. new_theme, vim.log.levels.INFO, true)
end

-- Load a theme and update all components
function M.load_theme(theme, config, components)
  theme = theme or config.theme
  config.theme = theme

  -- Set vim.o.background to match the theme
  vim.o.background = theme == "dark" and "dark" or "light"

  local ok, colors = pcall(require, "blackbeard." .. theme .. "-mode")
  if not ok or not colors then
    M.log("Blackbeard: Invalid theme specified: " .. theme .. " - " .. tostring(colors), vim.log.levels.ERROR, false)
    return
  end

  local theme_function = require("blackbeard.themes")[theme]
  if theme_function then
    local neovim_colors = theme_function(colors)
    M.apply_highlights(neovim_colors)
    -- Disable transparency to ensure the background is solid
    vim.o.winblend = 0
    vim.o.pumblend = 0
    -- Reapply the Normal highlight group to prevent overrides
    vim.api.nvim_set_hl(0, "Normal", { fg = neovim_colors.Normal.fg, bg = neovim_colors.Normal.bg })

    -- Update components (Alacritty, GTK, dmenu, etc.)
    for _, component in ipairs(components) do
      local component_name, update_function, param = unpack(component)
      local ok_component, err_component = pcall(update_function, param, config.font_size)
      if not ok_component then
        M.log(
          "Failed to update " .. component_name .. " theme: " .. tostring(err_component),
          vim.log.levels.ERROR,
          false
        )
      end
    end
  else
    M.log("Blackbeard: Theme function not found for " .. theme, vim.log.levels.ERROR, false)
  end

  -- Store the new theme
  M.store_theme(theme)
end

-- Create user commands for Blackbeard
function M.create_user_commands(load_function, toggle_function, config, components)
  vim.api.nvim_create_user_command("Blackbeard", function(opts)
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local action = args[1]
    local sub_action = args[2]

    if action == "light" or action == "dark" then
      if sub_action then
        M.log("Theme commands do not accept sub-actions.", vim.log.levels.ERROR, true)
        return
      end
      load_function(action)
      M.log("Loaded " .. action .. " theme.", vim.log.levels.INFO, true)
      return
    end

    if action == "toggle" then
      if sub_action then
        M.log("Toggle command does not accept sub-actions.", vim.log.levels.ERROR, true)
        return
      end
      toggle_function()
      return
    end

    if action == "fontsize" then
      if not sub_action then
        M.log("Fontsize requires a size (e.g., 16).", vim.log.levels.ERROR, true)
        return
      end
      local font_size = tonumber(sub_action)
      if not font_size or font_size <= 0 then
        M.log("Invalid font size: " .. sub_action, vim.log.levels.ERROR, true)
        return
      end
      config.font_size = font_size
      components.alacritty.update_font_size(font_size)
      M.log("Font size updated to " .. font_size, vim.log.levels.INFO, true)
      return
    end

    if action == "icon" then
      if not sub_action then
        M.log("Icon requires an icon theme name (e.g., Papirus-Dark).", vim.log.levels.ERROR, true)
        return
      end
      local icon_theme = sub_action
      if vim.fn.isdirectory("/usr/share/icons/" .. icon_theme) == 0 then
        M.log("Icon theme " .. icon_theme .. " not found in /usr/share/icons/", vim.log.levels.ERROR, true)
        return
      end
      M.update_icon_theme(icon_theme, M.get_current_theme(config))
      M.log("Icon theme set to " .. icon_theme, vim.log.levels.INFO, true)
      return
    end

    if action == "install-themes" then
      local source_dir = sub_action and vim.fn.expand(sub_action) or nil
      if source_dir and vim.fn.isdirectory(source_dir) == 0 then
        M.log("Source directory " .. source_dir .. " does not exist.", vim.log.levels.ERROR, true)
        return
      end
      components.gtk.install_themes(source_dir)
      M.log("User themes installed" .. (source_dir and " from " .. source_dir or ""), vim.log.levels.INFO, true)
      return
    end

    if action == "update" then
      if not sub_action then
        M.log("Update requires a sub-action (e.g., hyprland, gtk).", vim.log.levels.ERROR, true)
        return
      end
      if sub_action == "hyprland" then
        local success = os.execute("hyprpm reload")
        if success then
          M.log("Hyprland reloaded successfully.", vim.log.levels.INFO, true)
        else
          M.log("Failed to reload Hyprland.", vim.log.levels.ERROR, true)
        end
      elseif sub_action == "gtk" then
        components.gtk.update_theme(M.get_current_theme(config))
        M.log("GTK theme updated.", vim.log.levels.INFO, true)
      else
        M.log("Invalid update sub-action: " .. sub_action, vim.log.levels.ERROR, true)
      end
      return
    end

    M.log("Invalid action: " .. (action or ""), vim.log.levels.ERROR, true)
  end, { nargs = "*", desc = "Blackbeard theme and update manager" })
end

return M
