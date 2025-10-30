-- copied from https://github.com/majamin/nvim-lazy-starter/blob/master/lua/user/options.lua
-- Configuration options for Neovim
local o = vim.opt

-- Color scheme
vim.cmd([[colo catppuccin-macchiato]])
-- vim.cmd([[colo everforest]])
-- vim.cmd([[colo monokai-pro]])
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- Line numbers
o.number = true
o.relativenumber = true

-- Wrapping
o.wrap = false

-- Tabs and indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = false
vim.opt.autoindent = true

-- Appearance
o.termguicolors = true
o.signcolumn = "yes:1"
o.winborder = "rounded"
o.cursorline = true

-- Undo settings
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

-- Wildmenu settings
o.wildignorecase = true
o.wildmode = "full"

-- Scrolling
o.scrolloff = 8

-- Conceal settings
o.conceallevel = 1

-- Update time
o.updatetime = 25

vim.diagnostic.config({
	virtual_text = {
		virt_text_pos = "right_align",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
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
        au TextYankPost * silent! lua vim.hl.on_yank({higroup="Visual", timeout=200})
    augroup END
]])
