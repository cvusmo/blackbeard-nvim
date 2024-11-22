-- ~/blackbeard-nvim/lua/blackbeard/alacritty.lua

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

local function generate_alacritty_config(colors)
    return string.format([[
# Alacritty Colors and Font Configuration
[terminal.shell]
program = "/bin/fish"

[window]
padding = { x = 4, y = 4 }
dynamic_padding = true
decorations = "Full"
opacity = 0.98
blur = true
startup_mode = "Windowed"
dynamic_title = false

[scrolling]
history = 5000

[font]
size = 16  # Default font size
normal.family = "Hurmit Nerd Font"
bold.family = "Hurmit Nerd Font"
italic.family = "Hurmit Nerd Font"

[colors]
[colors.primary]
background = "%s"
foreground = "%s"

[colors.cursor]
text = "%s"
cursor = "%s"

[colors.selection]
text = "%s"
background = "%s"

[colors.normal]
black = "%s"
red = "%s"
green = "%s"
yellow = "%s"
blue = "%s"
magenta = "%s"
cyan = "%s"
white = "%s"

[colors.bright]
black = "%s"
red = "%s"
green = "%s"
yellow = "%s"
blue = "%s"
magenta = "%s"
cyan = "%s"
white = "%s"
]],
        colors.bg, colors.fg, -- Primary
        colors.cursor, colors.cursor, -- Cursor
        colors.selection_fg, colors.selection_bg, -- Selection
        colors.black, colors.red, colors.green, colors.yellow, colors.blue,
        colors.magenta, colors.cyan, colors.white, -- Normal
        colors.brblack, colors.brred, colors.brgreen, colors.bryellow,
        colors.brblue, colors.brmagenta, colors.brcyan, colors.brwhite -- Bright
    )
end

local palettes = {
    dark = {
        bg = "#1C1B1A",
        fg = "#F4E3C1",
        cursor = "#F27835",
        selection_bg = "#F4A259",
        selection_fg = "#1C1B1A",
        black = "#454240",
        red = "#D13438",
        green = "#73A857",
        yellow = "#F1C232",
        blue = "#5A8CA5",
        magenta = "#A066C9",
        cyan = "#46B9A0",
        white = "#AA9E87",
        brblack = "#614A4D",
        brred = "#FF5F56",
        brgreen = "#88C070",
        bryellow = "#FADF60",
        brblue = "#73B3D8",
        brmagenta = "#B794F4",
        brcyan = "#6FE2CA",
        brwhite = "#F6E8CD",
    },
    light = {
        bg = "#F4E3C1",
        fg = "#1C1B1A",
        cursor = "#F27835",
        selection_bg = "#F4A259",
        selection_fg = "#1C1B1A",
        black = "#454240",
        red = "#D13438",
        green = "#88C070",
        yellow = "#F1C232",
        blue = "#5A8CA5",
        magenta = "#A066C9",
        cyan = "#46B9A0",
        white = "#AA9E87",
        brblack = "#614A4D",
        brred = "#FF5F56",
        brgreen = "#88C070",
        bryellow = "#FADF60",
        brblue = "#73B3D8",
        brmagenta = "#A066C9",
        brcyan = "#73B3D8",
        brwhite = "#F6E8CD",
    },
}

function M.update_theme(theme)
    if not palettes[theme] then
        vim.notify("Invalid theme: " .. theme, vim.log.levels.ERROR)
        return
    end

    local alacritty_path = vim.fn.expand("~/.config/alacritty/alacritty.toml")
    local content = generate_alacritty_config(palettes[theme])

    if write_to_file(alacritty_path, content) then
        vim.notify("Alacritty theme updated to " .. theme .. " at: " .. alacritty_path, vim.log.levels.INFO)
    end
end

return M
