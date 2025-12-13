# Showkeys no-install fork

Neovim keycast script for TUI demos, almost an alternative to [vhs](https://github.com/charmbracelet/vhs) or [asciinema](https://github.com/asciinema/asciinema).

Many thanks to the original [nvzone/showkeys](https://github.com/nvzone/showkeys).

## Install

Copy/paste the shell script nvim lua command, and modify as needed.

## Usage

Run e.g.

``` sh
nvim -c 'lua '\
'recent_keypresses={} '\
'max_recent_keypresses=3 '\
'msg = " " '\
'width = vim.fn.strdisplaywidth(msg) '\
'buf = vim.api.nvim_create_buf(false, true) '\
'window_config = {relative="editor",width=width,height=1,col=0,row=1,style="minimal",border="solid"} '\
'window_id = nil '\
'hidden = false '\
'ns = vim.api.nvim_create_namespace("showkeysforknamespace") '\
'vim.api.nvim_set_hl(0, "PastHighlight", { default = true, link = "Visual" }) '\
'vim.api.nvim_set_hl(0, "CurrentHighlight", { default = true, link = "pmenusel" }) '\
''\
''\
'vim.on_key(function(_, char) '\
'  if hidden then '\
'    if window_id ~= nil then vim.api.nvim_win_close(window_id, true); end '\
'    window_id = nil '\
'    recent_keypresses = {} '\
'    return '\
'  end '\
'  if window_id == nil then window_id = vim.api.nvim_open_win(buf, false, window_config); end '\
'  vim.wo[window_id].winhl = "FloatBorder:Normal,Normal:Normal" '\
'  key = vim.fn.keytrans(char) '\
'  special_keys = {["<BS>"] = "󰁮 ",["<CR>"] = "󰘌",["<Space>"] = "󱁐",["<Up>"] = "󰁝",["<Down>"] = "󰁅",["<Left>"] = "󰁍",["<Right>"] = "󰁔",["<PageUp>"] = "Page 󰁝",["<PageDown>"] = "Page 󰁅",["<M>"] = "Alt",["<C>"] = "Ctrl"} '\
'  msg = special_keys[key] or key '\
'  table.insert(recent_keypresses, msg) '\
'  if #recent_keypresses > max_recent_keypresses then table.remove(recent_keypresses, 1) end '\
'  display_str = "  " .. table.concat(recent_keypresses, "   ") .. "  " '\
'  width = vim.fn.strdisplaywidth(display_str) '\
'  window_config.width = width '\
'  window_config.col = math.floor((vim.o.columns - width) / 2) '\
'  vim.api.nvim_win_set_config(window_id, window_config) '\
'  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {display_str}) '\
'  last_pos=1 '\
'  for i = 1, #recent_keypresses do '\
'    this_width = vim.fn.strlen(recent_keypresses[i]) '\
'    hl = "PastHighlight"; if i == #recent_keypresses then hl = "CurrentHighlight" end '\
'    vim.hl.range(buf, ns, hl, {0,last_pos}, {0,last_pos+this_width+2}) '\
'    last_pos = last_pos + 1 + this_width + 2 '\
'  end '\
'end) '\
''\
''\
'time = 0 '\
'T = function(inputs, delay_ms) vim.fn.timer_start(time + delay_ms, function() vim.api.nvim_input(inputs) end) time = time + delay_ms; end '\
'vim.cmd("terminal") '\
''\
'T("iecho ", 200) '\
'T("h", 200) '\
'T("e", 200) '\
'T("l", 200) '\
'T("l", 200) '\
'T("o", 200) '\
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
