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

local function set_visual(s_row, s_col, e_row, e_col)
	vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { e_row + 1, math.max(e_col - 1, 0) })
end

local function init_selection()
	local node = vim.treesitter.get_node()
	if not node then
		return
	end
	vim.b.ts_sel_node = node
	set_visual(node:range())
end

local function node_incremental()
	local node = vim.b.ts_sel_node or vim.treesitter.get_node()
	if not node then
		return
	end
	local parent = node:parent()
	if not parent then
		set_visual(node:range())
		return
	end
	vim.b.ts_sel_node = parent
	set_visual(parent:range())
end

local function node_decremental()
	local node = vim.b.ts_sel_node
	if not node then
		return
	end
	local child = node:child(0)
	if not child then
		return
	end
	vim.b.ts_sel_node = child
	set_visual(child:range())
end

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

			vim.keymap.set("n", "<Enter>", init_selection, { desc = "Treesitter: init selection" })
			vim.keymap.set("x", "<Enter>", node_incremental, { desc = "Treesitter: expand selection" })
			vim.keymap.set("x", "<Backspace>", node_decremental, { desc = "Treesitter: shrink selection" })
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
}
