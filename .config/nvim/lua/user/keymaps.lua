vim.g.mapleader = " "

local opts = { silent = true }
local expr_opts = { silent = true, expr = true }

local keymap = vim.keymap.set

keymap("n", "<ESC>", ":noh<CR>:lua require('notify').dismiss()<CR>", opts)

-- Move selection up and down, with indents
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in place when merging lines
keymap("n", "J", "mzJ`z")

-- Keep things in the middle
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Pasting doesn't overwrite clipboard with what was written over
keymap("x", "<leader>p", '"_dP')

-- Disable Q
keymap("n", "Q", "<nop")

-- Scroll through quick fixes
keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")

local harpoon = require("harpoon")

local wk = require("which-key")

wk.add({
	-- Copy to clipboard
	{ "<leader>y", '"+y', hidden = true },
	{ "<leader>y", '"+y', hidden = true },
	{ "<leader>Y", '"+Y', hidden = true },
	-- vim options
	{ "<leader>j", "<cmd>lprev<CR>zz", desc = "Scroll quickfix up" },
	{ "<leader>k", "<cmd>lprev<CR>zz", desc = "Scroll quickfix down" },
	-- Find
	{ "<leader>f", desc = "Find" },

	-- Replace current word
	{ "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Replace current word" },

	-- lsp
	{ "<leader>l", desc = "LSP" },
	{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
	{ "<leader>la", "<cmd> lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
	{ "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
	{ "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Definition" },
	{ "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Declaration" },
	{ "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation" },
	{ "<leader>lo", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Definition" },
	{ "<leader>lR", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "References" },
	{ "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature Help" },

	-- Git
	{ "<leader>g", "", desc = "git" },
	{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
	-- Buffers
	{ "<leader>b", desc = "Buffer" },
	{
		"<leader>ba",
		function()
			harpoon:list():add()
		end,
		desc = "Add current buffer to list",
	},
	{
		"<leader>bh",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "View Buffer List",
	},
	{
		"<leader>b1",
		function()
			harpoon:list():select(1)
		end,
		desc = "Select buffer 1",
	},
	{
		"<leader>b2",
		function()
			harpoon:list():select(2)
		end,
		desc = "Select buffer 2",
	},
	{
		"<leader>b3",
		function()
			harpoon:list():select(3)
		end,
		desc = "Select buffer 3",
	},
	{
		"<leader>b4",
		function()
			harpoon:list():select(4)
		end,
		desc = "Select buffer 4",
	},
})
