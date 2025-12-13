#!/bin/sh

# main components:
# on timer nvim_input() to automate sending of keys 
# vim.on_key(callback)
# vim.api.nvim_open_win() creates a popup dialog
#
# crudely adapted from https://github.com/nvzone/showkeys in all its GPL glory
# tested on nvim 0.11.5

# see also obs scripting, something like
# obs-cli call StartRecordl; ... obs-cli call StopRecord
#
# and todo: try testing in multiple nvim versions

# '  vim.api.nvim_win_close(window_id, true);'\
# '  msg=vim.fn.keytrans(char);'\
# '  vim.api.nvim_win_set_config(window_id, {...newconfigattribs...});'\
# '  if not visible then vim.api.nvim_win_close(window_id, true); return; end;'\
# '  vim.api.nvim_win_set_config(window_id, {relative="editor", width=width, row=0, col=math.floor((vim.o.columns - width) / 2)});'\
# '  vim.api.nvim_win_set_config(window_id, {relative="editor", width=width, row=0, col=0});'\
# '  vim.api.nvim_win_set_option(window_id, "winhl", "Normal:CurrentHighlight");'\
# '  vim.hl.range(buf, ns, "CurrentHighlight", {0,0}, {0,-1}, {});'\
#
nvim -c 'lua '\
'recent_keypresses={};'\
'max_recent_keypresses=3;'\
'msg = " ";'\
'width = vim.fn.strdisplaywidth(msg);'\
'buf = vim.api.nvim_create_buf(false, true);'\
'window_id = vim.api.nvim_open_win(buf, false, {relative="editor", width=width, height=1, col=0, row=0, style="minimal", border="rounded"});'\
'death_timer=0;'\
'vim.api.nvim_set_hl(0, "PastHighlight", { default = true, link = "Visual" });'\
'vim.api.nvim_set_hl(0, "CurrentHighlight", { default = true, link = "pmenusel" });'\
'ns = vim.api.nvim_create_namespace("mynamespace");'\
'print("makeshift comment");'\
'normal = vim.api.nvim_get_hl(0, { name = "Normal" });'\
'vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", fg=normal.fg })'\
'vim.api.nvim_set_hl(0, "Error", {})'\
'vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {})'\
'vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {})'\
'vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {})'\
'vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {})'\
'vim.api.nvim_set_hl(0, "SpellCap", {})'\
'vim.api.nvim_set_hl(0, "SpellLocal", {})'\
''\
'vim.on_key(function(_, char)'\
'  if hidden == true then'\
'    if window_id ~= nil then vim.api.nvim_win_close(window_id, true); end;'\
'    window_id = nil;'\
'    recent_keypresses = {};'\
'    return;'\
'  end;'\
'  if window_id == nil then window_id = vim.api.nvim_open_win(buf, false, {relative="editor", width=width, height=1, col=0, row=0, style="minimal", border="solid"}); end;'\
'  vim.wo[window_id].winhl = "FloatBorder:Normal,Normal:Normal";'\
'  key = vim.fn.keytrans(char);'\
'  special_keys = {["<BS>"] = "󰁮 ",["<CR>"] = "󰘌",["<Space>"] = "󱁐",["<Up>"] = "󰁝",["<Down>"] = "󰁅",["<Left>"] = "󰁍",["<Right>"] = "󰁔",["<PageUp>"] = "Page 󰁝",["<PageDown>"] = "Page 󰁅",["<M>"] = "Alt",["<C>"] = "Ctrl",};'\
'  msg = char;'\
'  msg = special_keys[key] or key;'\
'  table.insert(recent_keypresses, msg);'\
'  if #recent_keypresses > max_recent_keypresses then table.remove(recent_keypresses, 1) end'\
'  display_str = "  " .. table.concat(recent_keypresses, "   ") .. "  ";'\
'  width = vim.fn.strdisplaywidth(display_str);'\
'  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {display_str});'\
'  vim.api.nvim_win_set_config(window_id, {relative="editor", width=width, row=1, col=math.floor((vim.o.columns - width) / 2)});'\
'  last_pos=1;'\
'  for i = 1, #recent_keypresses do'\
'    len = vim.fn.strlen(recent_keypresses[i]);'\
'    hl = "PastHighlight"; if i == #recent_keypresses then hl = "CurrentHighlight" end;'\
'    vim.hl.range(buf, ns, hl, {0,last_pos}, {0,last_pos+len+2});'\
'    last_pos = last_pos + 1 + len + 2;'\
'  end;'\
'end);'\
''\
'time = 0;'\
'hidden = true;'\
'T = function(inputs, delay_ms) vim.fn.timer_start(time + delay_ms, function() vim.api.nvim_input(inputs) end) time = time + delay_ms; end;'\
'Hide = function() vim.fn.timer_start(time, function() hidden = true; end) end;'\
'Show = function() vim.fn.timer_start(time, function() hidden = false; end) end;'\
'vim.cmd("terminal");'\
''\
'Hide()'\
'T("avic ~/builds/vic/test/bbb_480p_24fps.avi --dry-run -w 80<CR>", 0)'\
'Show()'\
'T("?", 400)'\
'T("7", 800)'\
'T(" ", 800)'\
'T("j", 800)'\
'T("j", 800)'\
'T("<Left>", 800)'\
'T("m", 800)'\
'T("3", 800)'\
'T(" ", 800)'\
'T("m", 2000)'\
'T("J", 1000)'\
'T("L", 1000)'\
'T(" ", 1000)'\
'T("q", 3000)'\
'Hide()'\
'T("echo hello world<CR>", 1000)'\
'T("<ESC>:q!<CR>", 1000)'

# 'T(":set background=light<CR>", 0)'\

#      -c 'ShowkeysToggle' \
#      -c 'terminal' \
#      -c 'let g:time = 0| let g:hidden = 1|'\
# 'let T = {inputs,delay_ms -> timer_start(g:time+delay_ms,{->nvim_input(inputs)})+execute("let g:time+=delay_ms") } |'\
# 'let Hide = {-> timer_start(g:time,{->execute("let g:hidden=1")})} |'\
# 'let Show = {-> timer_start(g:time,{->execute("let g:hidden=0")})} |'\
# ''\
# 'call Hide() |'\
# 'call T("avic ~/builds/vic/test/bbb_480p_24fps.avi --dry-run -w 80<CR>", 0) |'\
# 'call Show() |'\
# 'call T("h", 400) |'\
# 'call T("7", 800) |'\
# 'call T(" ", 800) |'\
# 'call T("j", 800) |'\
# 'call T("j", 800) |'\
# 'call T("<Left>", 800) |'\
# 'call T("m", 800) |'\
# 'call T("3", 800) |'\
# 'call T(" ", 800) |'\
# 'call T("m", 2000) |'\
# 'call T("q", 3000) |'\
# 'call Hide() |'\
# 'call T("echo hello world<CR>", 1000) |'\
# 'call T("<ESC>:q!<CR>", 1000) |'

# 'call T("a",       0) |'\
# 'call T("echo",    400) |'\
# 'call T(" ",       400) |'\
# 'call T("hello ",  400) |'\
# 'call T("<Left>",  400) |'\
# 'call T("<Right>", 400) |'\
# 'call T("<C-i>",   400) |'\
# 'call T("<BS>",    400) |'\
# 'call T("<CR>",    1000) |'\
# 'call T("<ESC>:q!<CR>", 1000) |'

# 'call T("a",       0) |'\
# 'call T("h",       400) |'\
# 'call T("t",       400) |'\
# 'call T("o",       400) |'\
# 'call T("p",       400) |'\
# 'call T("<CR>",    400) |'\
# 'call T("t",    2000) |'\
# 'call T("<ESC>:q!<CR>", 5000) |'
