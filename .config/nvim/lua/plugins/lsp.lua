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
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"j-hui/fidget.nvim",
		},
		opts = {
			servers = {
				-- bash
				bashls = {},

				-- c
				clangd = {},

				-- docker
				docker_compose_language_service = {},

				-- eslint
				-- eslint = {
				-- 	on_attach = function(_, bufnr)
				-- 		vim.api.nvim_create_autocmd("BufWritePre", {
				-- 			buffer = bufnr,
				-- 			command = "EslintFixAll",
				-- 		})
				-- 	end,
				-- },

				-- go
				gopls = {},

				-- lua
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = {
									"vim",
								},
							},
						},
					},
				},

				--markdown
				marksman = {},

				-- nix
				nil_ls = {},

				-- python
				pyright = {},

				-- rust
				rust_analyzer = {
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
				},

				-- terraform
				terraformls = {
					cmd = { "terraform-ls", "serve" },
					filetypes = { "terraform", "hcl", "tf" },
				},

				tflint = {
					cmd = { "tflint" },
					filetypes = { "terraform" },
				},

				-- typescript/javascript
				-- vue
				volar = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					init_options = {
						vue = {
							-- disable hybrid mode
							hybridMode = false,
						},
					},
				},

				yamlls = {},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")

			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
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
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "nixpkgs_fmt" },
				python = { "isort", "black" },
				rust = { "rustfmt", "leptosfmt" },
				terraform = { "terraform_fmt" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				toml = { "taplo" },
				yaml = { "prettierd" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
