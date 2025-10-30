return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
				css = { "prettier" },
				go = { "gofmt" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "nixpkgs_fmt" },
				python = { "isort", "black" },
				rust = { "rustfmt", "leptosfmt" },
				terraform = { "terraform_fmt" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				toml = { "taplo" },
				yaml = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
