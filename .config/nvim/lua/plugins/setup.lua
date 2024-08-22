return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		keys = {
			{
				"<leader>ff",
				"<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
				desc = "Find files using grep",
			},
			{
				"<leader>fw",
				"<cmd>lua require('telescope.builtin').live_grep({additional_args = function() return {'--hidden'} end})<cr>",
				desc = "Find words using grep",
			},
			{
				"<leader>fd",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Find diagnostics",
			},
			{
				"<leader>fs",
				"<cmd>lua require('telescope.builtin').grep_string({additional_args = function() return {'--hidden'} end})<cr>",
				desc = "Find current string",
			},
			{
				"<leader>fb",
				"<cmd>Telescope file_browser<cr>",
				desc = "Find files using file browser",
			},
		},
		opts = {
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				file_browser = {},
			},
		},
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { theme = "everforest", disabled_filetypes = { "neo-tree" } },
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {},
	},
}
