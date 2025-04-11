<a href="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard"><img src="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard"><img src="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard/badges/leaderkey?style=for-the-badge" /></a>
<a href="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard"><img src="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard/badges/plugin-manager?style=for-the-badge" /></a>

# blackbeard.nvim

**blackbeard.nvim** is a modern, customizable Neovim color scheme designed for productivity. Heavily inspired by TokyoNight, Kanagawa, Cyberdream, and Gruvbox. blackbeard-nvim is in it's early life. Palette and finetuning will come. User feedback is appreciated.

## Preview

![blackbeard-nvim Demo](assets/preview/blackbeard-nvim.gif)

[Watch the blackbeard-nvim on YouTube](https://www.youtube.com/watch?v=VgWiPCSRz7g)

![blackbeard-nvim-preview](https://github.com/cvusmo/blackbeard-nvim/blob/dev/assets/preview/blackbeard-nvim-preview.png?raw=true)

## Features

- **Dark and Light Themes**: Inspired by popular colorschemes like Gruvbox, Kanagawa, TokyoNight, and Cyberdream.
- **System-Wide Integration**: Synchronizes Neovim, Alacritty, and GTK themes for a unified look across your desktop environment.
- **Customizable Appearance**: Use commands to switch themes, set Alacritty font sizes, and configure GTK icon themes.
- **Plugin Support**: Integrates with popular plugins such as Telescope, LSP, and more.
- **User-Friendly Installation**: Installs GTK themes to `~/.local/share/themes/` by default, with an option for system-wide installation.
- **Command-Driven Workflow**: Provides a powerful `:Blackbeard` command to manage themes, font sizes, icon themes, and external components like DWM and Hyprland.

### Commands

The `:Blackbeard` command is the primary way to interact with the plugin. Below is a table of all available commands and their descriptions:

| Command                     | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `:Blackbeard dark`          | Switches Neovim, Alacritty, and GTK themes to dark mode.                    |
| `:Blackbeard light`         | Switches Neovim, Alacritty, and GTK themes to light mode.                   |
| `:Blackbeard toggle`        | Toggles between dark and light themes for Neovim, Alacritty, and GTK.       |
| `:Blackbeard fontsize <size>` | Sets the font size for Alacritty (e.g., `:Blackbeard fontsize 16`). Restart Alacritty to apply changes. |
| `:Blackbeard icon <theme>`  | Sets the GTK icon theme (e.g., `:Blackbeard icon Papirus-Dark`). The theme must be installed in `/usr/share/icons/`. |
| `:Blackbeard install-themes`| Installs GTK themes to `/usr/share/themes/` (requires `sudo` access).       |
| `:Blackbeard update dwm`    | Updates the DWM (Dynamic Window Manager) theme to match the current theme.  |
| `:Blackbeard update hyprland` | Reloads Hyprland to apply theme changes.                                  |
| `:Blackbeard update gtk`    | Updates GTK theme configurations to reflect the current theme.              |

## Installation

# :black_heart: Blackbeard-nvim Plugin Update: Easy Installation with Lazy.nvim

Hey everyone! I’ve been working on my dotfiles and recently branched off my `blackbeard-nvim` plugin to add some cool features. It’s a simple Neovim plugin for toggling between dark and light themes, and it’s super easy to install using Lazy.nvim (note: this doesn’t work with Packer). Follow the steps below to get started! :rocket:

## Installation Instructions

1. **Visit the GitHub Repository**  
   Head over to the `blackbeard-nvim` repository:  
   [https://github.com/cvusmo/blackbeard-nvim](https://github.com/cvusmo/blackbeard-nvim)

2. **Add the Plugin to Your Neovim Config**  
   Open your Neovim configuration directory (usually `~/.config/nvim/`). If you don’t already have a `plugins` directory for Lazy.nvim, create one:  

```bash
mkdir -p ~/.config/nvim/lua/plugins
```

3.Create or Edit the Plugin File
Create (or edit) a file named blackbeard.lua in the ~/.config/nvim/lua/plugins/ directory:  
bash

touch ~/.config/nvim/lua/plugins/blackbeard.lua

4. Add the Plugin Configuration
Copy the following Lua code into ~/.config/nvim/lua/plugins/blackbeard.lua. This sets up the plugin with the default dark theme and adds a keybinding to toggle between dark and light themes:  

``` lua
-- ~/.config/nvim/lua/plugins/blackbeard.lua

return {
  "cvusmo/blackbeard-nvim",
  lazy = false,
  config = function()
    local ok, blackbeard = pcall(require, "blackbeard")
    if not ok then
      vim.notify("Failed to load blackbeard-nvim: " .. tostring(blackbeard), vim.log.levels.ERROR)
      return
    end

    -- Install GTK themes to ~/.local/share/themes/ during setup
    local gtk_ok, gtk = pcall(require, "blackbeard.gtk")
    if gtk_ok then
      gtk.install_themes()
    else
      vim.notify("Failed to load blackbeard.gtk module: " .. tostring(gtk), vim.log.levels.ERROR)
    end

    ok, _ = pcall(blackbeard.setup, {
      theme = "dark", -- Default theme: "dark" or "light"
      font_size = 24,
    })
    if not ok then
      vim.notify("Blackbeard setup failed", vim.log.levels.ERROR)
      return
    end
  end,
}
```

5. Sync Plugins with Lazy.nvim
Open Neovim and run the following command to install the plugin:  

```
:Lazy sync
```

6. This will download and install blackbeard-nvim from the master branch.
Test the Plugin  

    Restart Neovim 
    Press <leader>tt (e.g., if your leader key is the default \, this would be \tt) to toggle between the dark and light themes.  
    Or enter command :BlackbeardTheme dark OR :BlackbeardTheme light
    You should see your Neovim colorscheme switch between the two themes!

---

### Acknowledgements
Thank you to all who have created colorschmes for neovim. These four have been some of my favorites to use and their code was instrumental in setting up my own colorscheme. Thank you again!

- [Kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [Cyberdream](https://github.com/scottmckendry/cyberdream.nvim)
- [Tokyonight](https://github.com/folke/tokyonight.nvim)
- [Gruvbox](https://github.com/morhetz/gruvbox)

### Support Me

## Twitch
- I stream M-W-F-Sat on [twitch](https://www.twitch.tv/cvusmo) from 07:00AM EST to 01:00 PM EST. Come hang out in chat, and let me know what you're working on!

## Youtube
- [youtube](https://www.youtube.com/@cvusmo) New series coming in May 2025 - The Rust Book. We're going to go through the entire Rust book and make a tutorial you can follow along.

## x
- [x](https://www.x.com/cvusmo) Follow on x for more of day to day memes, random thoughts, and spicy fresh hot takes.

## Discord
- [Discord](https://discord.gg/WZH4XNgpem) Join the wormhole and be part of our growing community! Games, programming, share projects, and learn about the lustre game engine!
