# Showkeys no-install fork

Neovim keycast script for TUI demos, almost an alternative to [vhs](https://github.com/charmbracelet/vhs) or [asciinema](https://github.com/asciinema/asciinema).

Many thanks to the original [nvzone/showkeys](https://github.com/nvzone/showkeys).

## Install

Copy/paste the shell script nvim lua command, and modify as needed.

## Usage

Run e.g.

``` sh
nvim -c 'lua '\
...
'vim.cmd("terminal")'\
''\
'T("iecho ", 0)'\
'T("h", 200)'\
'T("e", 200)'\
'T("l", 200)'\
'T("l", 200)'\
'T("o", 200)'\
'T(" world<CR>", 200)'
```

and record the terminal window with e.g. [obs](https://obsproject.com/) or another piece of screen recording software.

## Motivation 

- improve TUI demos by showing keypresses
- prefer copy-pasting rather than dependency installations if possible
- avoid hassle of nvim plugin management
- use existing nvim capabilities rather than installing more software

## Support the original author

I don't have sponsorships or anything, but [nvzone](https://github.com/nvzone) does:

[![kofi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/siduck)
[![paypal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/siduck13)
[![buymeacoffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/siduck)
[![patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://www.patreon.com/siduck)
