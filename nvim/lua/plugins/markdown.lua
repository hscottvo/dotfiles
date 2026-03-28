-- For `plugins/markview.lua` users.
return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	keys = {
		{
			"<leader>m",
			"<cmd>Markview splitToggle<cr>",
			desc = "Toggle Markdown Preview",
		},
	},
}
