return {
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
				python = { "isort", "ruff" },
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
