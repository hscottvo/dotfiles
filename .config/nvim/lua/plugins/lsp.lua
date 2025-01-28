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
					"latex",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"rust",
					"sql",
					"terraform",
					"typst",
					"yaml",
				},
				sync_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},
				indent = { enable = true },
				incremental_selection = { enable = true },
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
			}
		end,
		config = function()
			-- bash
			require("lspconfig").bashls.setup({})

			-- c
			require("lspconfig").clangd.setup({})

			-- docker
			require("lspconfig").docker_compose_language_service.setup({})

			-- go
			require("lspconfig").gopls.setup({})

			-- lua
			require("lspconfig").lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
							},
						},
					},
				},
			})

			-- python
			require("lspconfig").pyright.setup({})

			-- rust
			require("lspconfig").rust_analyzer.setup({})

			-- terraform
			require("lspconfig").terraformls.setup({
				cmd = { "terraform-ls", "serve" },
				filetypes = { "terraform", "hcl", "tf" },
			})

			require("lspconfig").tflint.setup({
				cmd = { "tflint" },
				filetypes = { "terraform" },
			})

			-- etc
			require("lspconfig").nil_ls.setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
				go = { "gofmt" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "nixpkgs_fmt" },
				python = { "isort", "black" },
				terraform = { "terraform_fmt" },
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
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
}
