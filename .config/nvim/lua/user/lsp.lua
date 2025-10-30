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
				-- command = "clippy",
				-- extraArgs = {
				-- 	"--",
				-- 	"--no-deps",
				-- 	"-Dclippy::correctness",
				-- 	"-Dclippy::complexity",
				-- 	"-Wclippy::perf",
				-- 	"-Wclippy::pedantic",
				-- },
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
vim.lsp.enable("vue_ls")
vim.lsp.enable("yamlls")
