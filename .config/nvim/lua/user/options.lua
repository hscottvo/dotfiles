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
	virtual_text = {
		format = function(diagnostic)
			local lines = vim.split(diagnostic.message, "\n")
			return lines[1]
		end,
		prefix = "●", -- You can use any character here for the virtual text
		virt_text_pos = "right_align",
		suffix = " ",
	},
	signs = false, -- Disable signs in the sign column
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})
