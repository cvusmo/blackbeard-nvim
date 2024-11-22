<a href="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard"><img src="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard"><img src="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard/badges/leaderkey?style=for-the-badge" /></a>
<a href="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard"><img src="https://dotfyle.com/blacksheepcosmo/blackbeard-nvim-lua-blackbeard/badges/plugin-manager?style=for-the-badge" /></a>

# blackbeard.nvim

**blackbeard.nvim** is a modern, customizable Neovim color scheme designed for productivity. Heavily inspired by TokyoNight, Kanagawa, Cyberdream, and Gruvbox. blackbeard-nvim is in it's early life. Palette and finetuning will come. User feedback is appreciated.

## Preview

![blackbeard-nvim-preview](https://github.com/cvusmo/blackbeard-nvim/blob/dev/assets/preview/blackbeard-nvim-preview.png?raw=true)

## Features

- Dark and Light themes inspired by popular colorschemes like Gruvbox, Kanagawa, TokyoNight, and Cyberdream
- Integration with popular plugins such as Telescope, LSP, and more.

## Installation

To install `blackbeard.nvim`, you can use your favorite plugin manager.

### Using LazyVim:
```lua
return {
    "cvusmo/blackbeard-nvim",
    config = function()
        require("blackbeard").setup({
            theme = "dark", -- Change to "dark" or "light"
        })
    end,
}
```

## Usage
Once the plugin is installed, you can set the theme by simply changing theme = "dark" to theme = "light"

### Requirements (WIP)
- Neovim (latest stable version)

## Color Palette (WIP)

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

### Acknowledgements
Thank you to all who have created colorschmes for neovim. These four have been some of my favorites to use and their code was instrumental in setting up my own colorscheme. Thank you again!

- [Kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [Cyberdream](https://github.com/scottmckendry/cyberdream.nvim)
- [Tokyonight](https://github.com/folke/tokyonight.nvim)
- [Gruvbox](https://github.com/morhetz/gruvbox)

### Support Me

## Donate

![TWLOHA](https://panels.twitch.tv/panel-32185066-image-1aa09e79-4ba3-415d-a9f1-321b4ee42f91)
- Don't buy me a coffee. [Donate](https://www.twitch.tv/charity/cvusmo) To Write Love on Her Arms is a nonprofit movement dedicated to presenting hope and finding help for people struggling with depression, addiction, self-injury, and suicide. TWLOHA exists to encourage, inform, inspire, and invest directly into treatment and recovery. To Write Love on Her Arms before subscribing. I would rather any amount of $ go to helping someone get the help they need, than to me.

## Twitch
- I stream Weds-Sun on [twitch](https://www.twitch.tv/cvusmo) from 05:00 EST to 11:00 AM EST. Come hang out in chat, and let me know what you're working on! All active subscribers will be added to credits for Lustre game engine and other software I develop.

## Youtube
- [youtube](https://www.youtube.com/@cvusmo) Not as active as I used to be but plan on uploading Rust/Lua related content starting January 2025. Help me reach monetization by simply subscribing to the channel. Leave a comment and let me know what you'd be interested in. I plan on going through creating this blackbeard-nvim as a series. Then diving into Rust related projects to show how to create basic applications.

## x
- [x](https://www.x.com/cvusmo) Follow on x for more of day to day memes, random thoughts, and spicy fresh hot takes.
