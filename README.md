# blackbeard.nvim

**blackbeard.nvim** is a modern, customizable Neovim color scheme designed for productivity with full support for TreeSitter syntax highlighting and popular plugins. It’s optimized for fast startup times and supports Lua bytecode compilation.

## Preview
![blackbeard-nvim-preview](https://github.com/cvusmo/blackbeard-nvim/blob/dev/assets/preview/blackbeard-nvim-preview.png?raw=true)

## Features

- Extensive support for TreeSitter syntax highlighting and many popular plugins.
- Compilation to Lua byte code for super-fast startup times.
- Customizable palette and themes.
- Transparent background support.
- Integration with popular plugins such as Telescope, LSP, and Git-related tools.
- Compatibility with TrueColor terminals and optional undercurl support.

## Installation

To install `blackbeard.nvim`, you can use your favorite plugin manager.

### Using LazyVim:
```lua
-- ~/.config/nvim/init.lua

require("lazy").setup({
  {
    "blackbeard-nvim",
    config = function()
      require("blackbeard").setup({
        transparent = true,  -- Enable transparency
        theme = "dark",      -- Set theme to dark or light
        terminalColors = true, -- Enable terminal colors
      })
      vim.cmd("colorscheme blackbeard")  -- Apply the colorscheme
    end
  },
})
```

### Adding blackbeard-nvim as a plugin in LazyVim
```lua
return {
    -- Install the plugin from GitHub using the correct plugin name
    "cvusmo/blackbeard-nvim",  -- Directly specify the GitHub repo
    config = function()
        -- Setup the plugin
        require("blackbeard").setup({
            compile = false,  -- Enable compiling the colorscheme
            undercurl = true,  -- Enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            transparent = false,  -- Do not set background color
            dimInactive = false,  -- Dim inactive window (`hl-NormalNC`)
            terminalColors = true,  -- Define `vim.g.terminal_color_{0,17}`
            colors = {  -- Add/modify theme and palette colors
                palette = {},
                theme = { dark = {}, light = {} },
            },
            overrides = function(colors)  -- Modify built-in highlights
                return {}
            end,
            theme = "dark",  -- Set theme to dark or light
            background = {  -- Map the value of `background` option to a theme
                dark = "dark",  -- `vim.o.background = "dark"`
                light = "light"  -- `vim.o.background = "light"`
            },
        })
    end,
}
```

### Using Packer:
```lua
-- ~/.config/nvim/init.lua

-- Ensure Packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    print("Installing packer.nvim...")
    fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd("packadd packer.nvim")
  end
end

ensure_packer()

-- Packer setup
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use {
    "blackbeard-nvim",  -- Replace this with your Blackbeard Nvim repository
    config = function()
      require("blackbeard").setup({
        transparent = true,  -- Enable transparency
        theme = "dark",      -- Set theme to dark
        terminalColors = true,  -- Enable terminal colors
      })
      vim.cmd("colorscheme blackbeard")  -- Apply the colorscheme
    end
  }

  -- Add more plugins here as needed
end)
```

### Requirements
- Neovim (latest stable version)
- Truecolor terminal support
- Optional: Undercurl terminal support

## Usage

Once the plugin is installed, you can set the theme by adding the following line to your `init.lua` or `init.vim`:

```lua
vim.cmd("colorscheme blackbeard")
```

You can also use:

```lua
require("blackbeard").setup({
    transparent = false,         -- Enable or disable transparency
    theme = "dark",              -- Default theme, choose between "dark", "light"
    terminalColors = true,       -- Enable terminal colors
    colors = {                   -- Modify theme and palette colors
        palette = {},             -- Modify palette
        theme = { dark = {}, light = {} },  -- Modify themes
    },
    overrides = function(colors)  -- Modify highlight groups
        return {}
    end
})
```

## Configuration

You can customize the `blackbeard.nvim` color scheme by setting the following options:

### Default Options:
```lua
require('blackbeard').setup({
    compile = false,             -- Enable compiling the colorscheme
    undercurl = true,            -- Enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- Do not set background color
    dimInactive = false,         -- Dim inactive window (`hl-NormalNC`)
    terminalColors = true,       -- Define `vim.g.terminal_color_{0,17}`
    colors = {                   -- Add/modify theme and palette colors
        palette = {},
        theme = { dark = {}, light = {} },
    },
    overrides = function(colors)  -- Modify built-in highlights
        return {}
    end,
    theme = "dark",              -- Set theme to dark or light
    background = {               -- Map the value of `background` option to a theme
        dark = "dark",           -- `vim.o.background = "dark"`
        light = "light"          -- `vim.o.background = "light"`
    },
})
```

### Customizing Palette and Themes:
You can modify the palette and themes as per your needs:
```lua
require('blackbeard').setup({
    colors = {
        palette = {
            -- Modify all usages of these colors
            sumiInk0 = "#000000",
            fujiWhite = "#FFFFFF",
        },
        theme = {
            dark = {
                ui = { bg = "none" },  -- Transparent background for dark theme
            },
            light = {
                syn = { parameter = "yellow" },  -- Set parameter color to yellow
            },
            all = {
                ui = { bg_gutter = "none" }  -- Remove gutter background
            }
        }
    }
})
```

### Using Overrides:
You can modify any highlight groups using the `overrides` function:
```lua
require('blackbeard').setup({
    overrides = function(colors)
        return {
            String = { fg = colors.palette.carpYellow, italic = true },  -- Customize String color
            SomePluginHl = { fg = colors.theme.syn.type, bold = true },  -- Customize plugin highlight
        }
    end
})
```

## Color Palette

| Name             | Hex      | Usage                            |
|------------------|----------|----------------------------------|
| deepRetroBrown   | #1C1B1A  | Dark background                  |
| warmRetroCream   | #F4E3C1  | Default foreground               |
| darkGrayishBlue  | #1F1F28  | Default background               |
| mutedAvocadoGreen| #73A857  | Git Add                          |
| vibrantRetroRed  | #D13438  | Git Delete                       |
| goldenMustard    | #F1C232  | Git Change                       |
| retroOrange      | #F27835  | Cursor color                     |
| softRetroTeal    | #5A8CA5  | Diff Change (background)         |
| softLavender     | #A066C9  | Diff Deleted (background)        |
| mintGreen        | #46B9A0  | Diff Line (background)           |
| warmRetroWhite   | #F4E3C1  | Default foreground               |
| softerDeepBrown  | #484441  | Non-text, comment color          |
| vibrantCoralRed  | #FF5F56  | Bright Git Add                   |
| brightRetroLime  | #88C070  | Bright Git Change                |
| lightRetroTeal   | #73B3D8  | Bright Diff Line                 |
| pastelLilac      | #B794F4  | Git Diff (background)            |
| brightGoldenYellow| #FADF60 | Bright Git Change                |
| brightAquaGreen  | #6FE2CA  | Bright Diff Add                  |
| pureWhite        | #FFFFFF  | Bright Git Delete                |

---

