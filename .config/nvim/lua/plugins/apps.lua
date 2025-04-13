return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/obsidian",
				},
			},

			-- see below for full list of options 👇
		},
	},
	{
		"mikavilpas/yazi.nvim",
		opts = {
			yazi_floating_window_border = "none",
		},
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>-",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open file browser at current file",
			},
			{
				-- Open in the current working directory
				"<leader>fb",
				"<cmd>Yazi cwd<cr>",
				desc = "Open new file browser",
			},
			{
				"<leader>fc",
				"<cmd>Yazi toggle<cr>",
				desc = "Continue file browser session",
			},
		},
	},
}
