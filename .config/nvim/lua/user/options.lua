-- copied from https://github.com/majamin/nvim-lazy-starter/blob/master/lua/user/options.lua
local o = vim.opt

vim.cmd([[colo nord]])

o.number = true
o.relativenumber = true
o.wrap = false

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.termguicolors = true
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true
o.wildignorecase = true
o.wildmode = "full"
o.scrolloff = 8
o.conceallevel = 1

vim.g.qs_highlight_on_keys = { "f", "t" }

vim.diagnostic.config({
	virtual_text = false,
	float = { border = "rounded" },
	signs = true, -- Disable signs in the sign column
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]])
