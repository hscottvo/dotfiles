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
					"python",
					"rust",
					"sql",
					"terraform",
					"tsx",
					"typescript",
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
				completion = {
					skip_after = { "\n", "\t", ";", "{", "}", "(", ")", "[", "]", ",", " " },
				},
				display = {
					mark_applied_notify = false,
				},
			}
		end,
		config = function()
			-- bash
			require("lspconfig").bashls.setup({})

			-- c
			require("lspconfig").clangd.setup({})

			-- docker
			require("lspconfig").docker_compose_language_service.setup({})

			-- eslint
			require("lspconfig").eslint.setup({
				cmd = { "eslint_d", "--stdin", "--stdin-filename", "%filepath" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			})

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

			--markdown
			require("lspconfig").marksman.setup({})

			-- python
			require("lspconfig").pyright.setup({})

			-- rust
			require("lspconfig").rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						-- Other Settings ...
						rustfmt = {
							overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
						},
						procMacro = {
							ignored = {
								leptos_macro = {
									-- optional: --
									-- "component",
									"server",
								},
							},
						},
					},
				},
			})

			-- terraform
			require("lspconfig").terraformls.setup({
				cmd = { "terraform-ls", "serve" },
				filetypes = { "terraform", "hcl", "tf" },
			})

			require("lspconfig").tflint.setup({
				cmd = { "tflint" },
				filetypes = { "terraform" },
			})

			require("lspconfig").ts_ls.setup({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html" },
				settings = {
					html = {
						format = {
							templating = true,
						},
					},
				},
			})

			require("lspconfig").yamlls.setup({
				-- settings = {
				-- 	yaml = {
				-- 		schemas = {
				-- 			["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
				-- 		},
				-- 		validate = true,
				-- 		format = { enable = true },
				-- 	},
				-- },
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
				css = { "prettierd" },
				go = { "gofmt" },
				html = { "prettierd" },
				json = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "nixpkgs_fmt" },
				python = { "isort", "black" },
				rust = { "rustfmt", "leptosfmt" },
				terraform = { "terraform_fmt" },
				typescript = { "prettierd" },
				toml = { "taplo" },
                typescriptreact = { "prettierd" },
                vue = { "prettier" },
				yaml = { "prettierd" },
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
		"windwp/nvim-ts-autotag",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		config = function()
			require("nvim-ts-autotag").setup({
				-- enable_close = true,
				-- enable_rename = true,
				-- enable_close_on_slash = true,
			})
		end,
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
