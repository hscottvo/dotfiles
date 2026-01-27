vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("docker_language_server")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("eslint")
vim.lsp.enable("gopls")
vim.lsp.enable("helm_ls")
vim.filetype.add({
	extension = {
		yaml = function(path, _)
			-- Check if we're in a helm chart's templates directory
			if path:match("helm/.*/templates/.*%.yaml$") then
				return "helm"
			end
			return "yaml"
		end,
		yml = function(path, _)
			if path:match("helm/.*/templates/.*%.yml$") then
				return "helm"
			end
			return "yaml"
		end,
	},
	filename = {
		["values.yaml"] = function(path, _)
			if path:match("helm/") then
				return "yaml.helm-values"
			end
			return "yaml"
		end,
	},
})

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
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
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
vim.lsp.enable("vuels")
vim.lsp.enable("yamlls")
