#!/usr/bin/env -S nvim -S

-- crudely adapted from https://github.com/nvzone/showkeys in all its GPL glory
-- tested on nvim 0.11.5
-- i'm new to lua and nvim apis, so this code is likely unidiomatic and clunky. suggestions welcome.
--
-- todo: death_timer for popup window (i like 0.75 secs)
-- 
-- todo: try incorporating obs scripting, something like:
-- obs-cli call StartRecordl; ... obs-cli call StopRecord
-- 
-- and todo: try testing in multiple nvim versions
--
-- also consider: disabling default config with nvim -u NORC, for reproducibility

-- main ingredients:
-- on timer nvim_input() to automate sending of keys 
-- vim.on_key(callback)
-- vim.api.nvim_open_win() creates a popup dialog

-- init global state and config:
recent_keypresses={} -- treat as a queue, append(newest, end) and remove(oldest, beginning)
max_recent_keypresses=3
msg = " "
width = vim.fn.strdisplaywidth(msg)
buf = vim.api.nvim_create_buf(false, true)
window_config = {
	relative="editor",
	width=width,
	height=1,
	col=0,
	row=1,
	style="minimal", -- undecorated buffer
	border="solid"   -- see also bold, double, none, rounded, shadow, solid, 
	                 -- or [""] or ["", "", "", ""] or ["", "", "", "", "", "", "", ""]
}
window_id = nil
hidden = true
ns = vim.api.nvim_create_namespace("showkeysforknamespace") -- highlights api requires a namespace?
-- make aliases for highlight types
vim.api.nvim_set_hl(0, "PastHighlight", { default = true, link = "Visual" })
vim.api.nvim_set_hl(0, "CurrentHighlight", { default = true, link = "pmenusel" })

-- trying to address a difficult-to-reproduce oddity:
-- sometimes, the popup window will flash red
-- this combination of highlight disablings seems to prevent that
--
-- normal = vim.api.nvim_get_hl(0, { name = "Normal" });
-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", fg=normal.fg })
-- vim.api.nvim_set_hl(0, "Error", {})
-- vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {})
-- vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {})
-- vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {})
-- vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {})
-- vim.api.nvim_set_hl(0, "SpellCap", {})
-- vim.api.nvim_set_hl(0, "SpellLocal", {})

close_window_and_reset = function()
    if window_id ~= nil then vim.api.nvim_win_close(window_id, true); end
    window_id = nil
    recent_keypresses = {}
    hidden = true
end

vim.on_key(function(_, char)

  if hidden then close_window_and_reset(); return; end

  if window_id == nil then window_id = vim.api.nvim_open_win(buf, false, window_config); end
  vim.wo[window_id].winhl = "FloatBorder:Normal,Normal:Normal" -- make window bgcolor match normal bgcolor
  key = vim.fn.keytrans(char) -- turn e.g. ^H into a more-readable format like <BS>
  special_keys = {
	  ["<BS>"] = "󰁮 ",
	  ["<CR>"] = "󰘌",
	  ["<Space>"] = "󱁐",
	  ["<Up>"] = "󰁝",
	  ["<Down>"] = "󰁅",
	  ["<Left>"] = "󰁍",
	  ["<Right>"] = "󰁔",
	  ["<PageUp>"] = "Page 󰁝",
	  ["<PageDown>"] = "Page 󰁅",
	  ["<M>"] = "Alt",
	  ["<C>"] = "Ctrl", -- TODO: fix Ctrl keypresses not being parsed
  }
  msg = char
  msg = special_keys[key] or key
  table.insert(recent_keypresses, msg)
  if #recent_keypresses > max_recent_keypresses then table.remove(recent_keypresses, 1) end
  -- generous display padding
  display_str = "  " .. table.concat(recent_keypresses, "   ") .. "  "
  width = vim.fn.strdisplaywidth(display_str)
  window_config.width = width
  window_config.col = math.floor((vim.o.columns - width) / 2) -- centered
  vim.api.nvim_win_set_config(window_id, window_config)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {display_str})

  last_pos=1
  for i = 1, #recent_keypresses do
    this_width = vim.fn.strlen(recent_keypresses[i])
    hl = "PastHighlight"; if i == #recent_keypresses then hl = "CurrentHighlight" end
    -- highlight from {linestart, colstart} to {lineend, colend}
    -- importantly, this is measured in chars (strlen), not glyphs (strdisplaywidth)
    vim.hl.range(buf, ns, hl, {0,last_pos}, {0,last_pos+this_width+2})
    last_pos = last_pos + 1 + this_width + 2 -- account for padding
  end
end)

accumulated_time = 0
Type = function(inputs, delay_ms) vim.fn.timer_start(accumulated_time + delay_ms, function() vim.api.nvim_input(inputs) end) accumulated_time = accumulated_time + delay_ms; end
-- e.g. Hide() keycast when typing a boring command
Hidekeys = function() vim.fn.timer_start(accumulated_time, close_window_and_reset) end
-- e.g. Show() keycast when the TUI is active
Showkeys = function() vim.fn.timer_start(accumulated_time, function() hidden = false; end) end
vim.cmd("terminal")

-- special keys, in case you need them:
-- <ESC> <CR> <BS> <Del> <C-x> <M-x> <Up> <Down> <Left> <Right> <Home> <End> <PageUp> <PageDown> <Insert>
-- demo script below:
Hidekeys()
Type("avic ~/builds/vic/test/bbb_480p_24fps.avi --dry-run -w 80<CR>", 0)
Showkeys()
Type("?", 400)
Type("7", 800)
Type(" ", 800)
Type("j", 800)
Type("j", 800)
Type("<Left>", 800)
Type("m", 800)
Type("3", 800)
Type(" ", 800)
Type("m", 2000)
Type("J", 1000)
Type("L", 1000)
Type(" ", 1000)
Type("q", 3000)
Hidekeys()
Type("echo hello world<CR>", 1000)
Type("<ESC>:q!<CR>", 1000)

--  see also:
--  T(":set background=light<CR>", 0)
