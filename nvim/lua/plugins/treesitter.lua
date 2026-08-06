local parsers = {
	"bash",
	"c",
	"cpp",
	"css",
	"dockerfile",
	"eex",
	"elixir",
	"go",
	"hcl",
	"heex",
	"helm",
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
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					if not lang then
						return
					end
					local ok = pcall(vim.treesitter.start, args.buf, lang)
					if not ok then
						return
					end
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
}
