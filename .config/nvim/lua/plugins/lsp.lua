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
					"css",
					"dockerfile",
					"go",
					"hyprlang",
					"lua",
					"markdown",
					"python",
					"rust",
					"sql",
					"yaml",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
		dependencies = {
			{ "ms-jpq/coq_nvim", branch = "coq" },
			{ "ms-jpq/coq.artifacts", branch = "artifacts" },
			{ "ms-jpq/coq.thirdparty", branch = "3p" },
		},
		init = function()
			vim.g.coq_settings = {
				auto_start = "shut-up",
				completion = {
					always = false,
				},
				display = {
					preview = {
						border = "rounded",
					},
				},
			}
		end,
		config = function()
			require("lspconfig").lua_ls.setup({})
			require("lspconfig").rust_analyzer.setup({})
			require("lspconfig").pyright.setup({})
			require("lspconfig").clangd.setup({})
			require("lspconfig").bashls.setup({})
			require("lspconfig").docker_compose_language_service.setup({})
			require("lspconfig").nil_ls.setup({
				settings = {
					nil_ls = {
						formatter = {
							command = {
								"nixpkgs-fmt",
							},
						},
					},
				},
			})
			-- Your LSP settings here
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				cpp = { "clang-format" },
				nix = { "nixpkgs_fmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
	-- old autocomplete, less pain in the butt to set up than COQ
	-- { "hrsh7th/cmp-nvim-lsp" },
	-- { "hrsh7th/nvim-cmp" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
}
