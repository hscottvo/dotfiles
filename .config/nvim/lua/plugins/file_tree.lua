return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		opts = {},
		keys = {
			"<leader>-",
			"<cmd>Oil<cr>",
			desc = "Oil File Explorer",
		},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		opts = {
			close_if_last_window = true,
		},
		lazy = false, -- neo-tree will lazily load itself
		keys = {
			{
				"<leader>e",
				"<cmd>Neotree toggle<cr>",
				desc = "NeoTree File Explorer",
			},
		},
	},
}
