vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("eslint")
vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.lsp.enable("marksman")
vim.lsp.enable("nil_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
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
})
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.lsp.enable("ts_ls")
vim.lsp.enable("volar")
vim.lsp.enable("yamlls")

-- return {
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		lazy = false,
-- 		dependencies = {
-- 			"j-hui/fidget.nvim",
-- 		},
-- 		opts = {
-- 			servers = {
-- 				-- eslint
-- 				-- eslint = {
-- 				-- 	on_attach = function(_, bufnr)
-- 				-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 				-- 			buffer = bufnr,
-- 				-- 			command = "EslintFixAll",
-- 				-- 		})
-- 				-- 	end,
-- 				-- },
--
-- 				-- go
-- 				gopls = {},
--
-- 				--markdown
-- 				marksman = {},
--
-- 				-- nix
-- 				nil_ls = {},
--
-- 				-- python
-- 				pyright = {},
--
-- 				-- terraform
-- 				terraformls = {
-- 					cmd = { "terraform-ls", "serve" },
-- 					filetypes = { "terraform", "hcl", "tf" },
-- 				},
-- 				tflint = {
-- 					cmd = { "tflint" },
-- 					filetypes = { "terraform" },
-- 				},
--
-- 				-- typescript/javascript
-- 				ts_ls = {
-- 					filetypes = {
-- 						"javascript",
-- 						"javascriptreact",
-- 						"javascript.jsx",
-- 						"typescript",
-- 						"typescriptreact",
-- 						"typescript.tsx",
-- 					},
-- 				},
--
-- 				-- vue
-- 				volar = {
-- 					filetypes = { "vue" },
-- 					init_options = {
-- 						vue = {
-- 							-- disable hybrid mode
-- 							hybridMode = false,
-- 						},
-- 					},
-- 				},
--
-- 				yamlls = {},
-- 			},
-- 		},
-- 		config = function(_, opts)
-- 			local lspconfig = require("lspconfig")
--
-- 			for server, config in pairs(opts.servers) do
-- 				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
-- 				lspconfig[server].setup(config)
-- 			end
-- 		end,
-- 	},
-- }
