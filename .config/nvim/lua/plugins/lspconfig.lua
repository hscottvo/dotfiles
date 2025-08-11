return {
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
							checkOnSave = {
								command = "clippy",
								extraArgs = {
									"--",
									"--no-deps",
									"-Dclippy::correctness",
									"-Dclippy::complexity",
									"-Wclippy::perf",
									"-Wclippy::pedantic",
								},
							},
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
				ts_ls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
				},

				-- vue
				volar = {
					filetypes = { "vue" },
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
}
