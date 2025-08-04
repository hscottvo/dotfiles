return {
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
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
