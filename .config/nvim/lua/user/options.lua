-- copied from https://github.com/majamin/nvim-lazy-starter/blob/master/lua/user/options.lua
local o = vim.opt

-- vim.cmd([[colo catppuccin-frappe]])
vim.cmd([[colo everforest]])

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
o.updatetime = 25
o.signcolumn = "yes:1"

vim.diagnostic.config({
	virtual_text = {
		virt_text_pos = "right_align",
	},
	-- float = {
	-- 	border = "single",
	-- 	max_width = 80,
	-- 	max_height = 5,
	-- 	relative = "editor", -- Use 'editor' for positioning relative to the entire editor
	-- 	row = 0, -- Position at the top of the screen
	-- 	col = vim.o.columns - 1,
	-- 	focusable = false,
	-- },
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		vim.diagnostic.config({
			virtual_text = {
				virt_text_pos = "right_align",
				format = function(diagnostic)
					if diagnostic.lnum == vim.fn.line(".") - 1 then
						return ""
					end
					return diagnostic.message
				end,
			},
		})
	end,
})

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd([[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
    augroup END
]])
