-- For `plugins/markview.lua` users.
return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	dependencies = { "saghen/blink.cmp" },
	keys = {
		{
			"<leader>m",
			"<cmd>Markview splitToggle<cr>",
			desc = "Toggle Markdown Preview",
		},
	},
}
