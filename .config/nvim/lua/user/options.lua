-- copied from https://github.com/majamin/nvim-lazy-starter/blob/master/lua/user/options.lua
local fn = vim.fn
local o = vim.opt
local g = vim.g

vim.cmd([[colo everforest]])

o.number = true
o.relativenumber = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.termguicolors = true
o.undodir = fn.stdpath("data") .. "/undodir"
o.undofile = true
o.wildignorecase = true
o.wildmode = "full"
o.scrolloff = 8

vim.g.qs_highlight_on_keys = { "f", "t" }

vim.diagnostic.config({ update_in_insert = true })
