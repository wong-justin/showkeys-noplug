# Showkeys no-install fork

Keycast script for CLI/TUI demos, using Neovim. 

Like [vhs](https://github.com/charmbracelet/vhs) or [asciinema](https://github.com/asciinema/asciinema) but without the video recording.

Many thanks to the original [nvzone/showkeys](https://github.com/nvzone/showkeys).

<img width="459" height="344" alt="hello world terminal screenshot, with last three keypresses shown in cute lil boxes" src="https://github.com/user-attachments/assets/401b024e-9b0a-4be2-864e-4ebcae944b3b" />

## Usage

Copy/paste this shell script, modifying as needed (especially the final part):

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
'close_window_and_reset = function() '\
'    if window_id ~= nil then vim.api.nvim_win_close(window_id, true); end '\
'    window_id = nil '\
'    recent_keypresses = {} '\
'    hidden = true '\
'end '\
'vim.on_key(function(_, char) '\
'  if hidden then close_window_and_reset(); return; end '\
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

Record the terminal window with [obs](https://obsproject.com/) or another piece of screen recording software.

## Motivation 

- improve TUI demos by showing keypresses
- avoid hassle of nvim plugin management
- avoid installing anything
- I like copy-pasteable snippets

## Support the original author

Here are the original donation links from [nvzone](https://github.com/nvzone): [Kofi](https://ko-fi.com/siduck), [PayPal](https://paypal.me/siduck13), [Buy me a coffee](https://www.buymeacoffee.com/siduck), and [Patreon](https://www.patreon.com/siduck).
