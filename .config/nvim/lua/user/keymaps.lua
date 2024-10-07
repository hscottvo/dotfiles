vim.g.mapleader = " "

local opts = { silent = true }
local expr_opts = { silent = true, expr = true }

local keymap = vim.keymap.set

keymap({ "n" }, "<ESC>", ":noh<CR>:lua require('notify').dismiss()<CR>", opts)

local harpoon = require("harpoon")

local wk = require("which-key")

wk.add({
	-- Find
	{ "<leader>f", desc = "Find" },

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

	{ "<leader>h", group = "Hop" },
})
