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

-- Window navigation from terminal mode using Alt-hjkl (exits terminal, then navigates)
keymap("n", "<M-h>", "<C-\\><C-n><C-w>h", opts)
keymap("n", "<M-j>", "<C-\\><C-n><C-w>j", opts)
keymap("n", "<M-k>", "<C-\\><C-n><C-w>k", opts)
keymap("n", "<M-l>", "<C-\\><C-n><C-w>l", opts)

-- Scroll through quick fixes
keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")

local wk = require("which-key")

wk.add({
	{ "<leader>-", "<cmd>Oil<cr>", desc = "Oil File Explorer" },
	-- Copy to clipboard
	{ "<leader>y", '"+y', hidden = true },
	{ "<leader>Y", '"+Y', hidden = true },
	{ "<leader>p", '"+p', hidden = true },
	{ "<leader>P", '"+P', hidden = true },
	-- vim options
	{ "<leader>j", "<cmd>lprev<CR>zz", desc = "Scroll quickfix up" },
	{ "<leader>k", "<cmd>lprev<CR>zz", desc = "Scroll quickfix down" },
	-- Find
	{ "<leader>f", desc = "Find" },

	-- Replace current word
	{ "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Replace current word" },

	-- lsp
	{ "gr", desc = "LSP" },
	{ "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
	{ "gra", "<cmd> lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
	{ "grf", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Hover" },
	{ "grd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Definition" },
	{ "grD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Declaration" },
	{ "gri", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation" },
	{ "grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Definition" },
	{ "grr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "References" },
	{ "grs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature Help" },
	{
		"grT",
		"<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
		desc = "Toggle Inlay Hints",
	},
	{ "<leader>w", "<cmd> noa w<cr>", desc = "Write without Formatting" },

	-- Git
	{ "<leader>g", "", desc = "git" },
	{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
})
