return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			build = ":TSUpdate",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"dockerfile",
					"go",
					"hcl",
					"html",
					"hyprlang",
					"javascript",
					"latex",
					"lua",
					"markdown",
					"markdown_inline",
					"nix",
					"python",
					"rust",
					"sql",
					"terraform",
					"tsx",
					"typescript",
					"typst",
					"vue",
					"yaml",
				},
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Enter>",
						node_incremental = "<Enter>",
						scope_incremental = false,
						node_decremental = "<Backspace>",
					},
				},
			})
		end,
	},
}
