vim.g.mapleader = " "

local opts = { silent = true }
local expr_opts = { silent = true, expr = true }

local keymap = vim.keymap.set

keymap({ "n" }, "<ESC>", ":noh<CR>:lua require('notify').dismiss()<CR>", opts)
--keymap({ "n" }, "<ESC>", ":lua require('notify').dismiss()<CR>")

-- local lsp_zero = require("lsp-zero")
--
-- local lsp_attach = function(client, bufnr)
-- 	local opts = {buffer = buffnr}
-- 	keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
-- 	keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
-- 	keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
-- 	keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
-- 	keymap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
-- 	keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
-- 	keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
-- 	keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
-- 	keymap({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
-- 	keymap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
-- end
--
-- lsp_zero.extend_lspconfig({
-- 	sign_text = true,
-- 	lsp_attach = lsp_attach,
-- 	capabilities = require("cmp_nvim_lsp").default_capabilities(),
-- })

local harpoon = require("harpoon")

local wk = require("which-key")

wk.add({
	-- Find
	{ "<leader>f", desc = "Find" },

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
