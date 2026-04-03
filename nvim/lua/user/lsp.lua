local function enable_if(name)
	if
		vim.fn.executable(vim.lsp.config[name] and vim.lsp.config[name].cmd and vim.lsp.config[name].cmd[1] or name)
		== 1
	then
		vim.lsp.enable(name)
		return true
	end
	return false
end

enable_if("bashls")
enable_if("clangd")
vim.lsp.config("expert", {
	cmd = { "expert", "--stdio" },
	root_markers = { "mix.exs", ".git" },
	filetypes = { "elixir", "eelixir", "heex", "surface", "ex" },
})
enable_if("expert")
enable_if("docker_language_server")
enable_if("docker_compose_language_service")
enable_if("eslint")
enable_if("gopls")
enable_if("helm_ls")
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

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
enable_if("lua_ls")

if not enable_if("rumdl") then
	enable_if("marksman")
end

enable_if("nil_ls")
vim.lsp.config("pyright", {
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				venvPath = ".",
				venv = ".venv",
			},
		},
	},
})
enable_if("pyright")
vim.lsp.config("ruff", {
	init_options = {
		settings = {
			organizeImports = false,
		},
	},
})
enable_if("ruff")
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
enable_if("rust_analyzer")
enable_if("terraformls")
enable_if("tflint")
enable_if("ts_ls")
enable_if("vuels")
enable_if("yamlls")
