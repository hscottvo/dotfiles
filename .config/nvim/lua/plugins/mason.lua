local function isNixOS()
	local file = io.open("/etc/os-release", "r")
	if not file then
		return false
	end

	for line in file:lines() do
		if line:match("^ID=nixos") then
			file:close()
			return true
		end
	end

	file:close()
	return false
end

if isNixOS then
	return {}
else
	return {
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"pyright",
					"clangd",
					"bashls",
					"docker_compose_language_service",
					"nil_ls",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					rust_analyzer = function()
						require("lspconfig").rust_analyzer.setup({
							testExplorer = true,
						})
					end,
				},
			},
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			--config = function()jk
			opts = {
				ensure_installed = {
					-- python
					"black",
					"isort",
					"mypy",
					-- lua
					"stylua",
					-- c++
					"clang-format",
					-- bash
					"shfmt",
					-- hypr
					"hyprls",
					-- zshrc
					"beautysh",
					-- nix
					"nil_ls",
				},
			},
		},
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
						"css",
						"dockerfile",
						"go",
						"hyprlang",
						"lua",
						"markdown",
						"python",
						"rust",
						"sql",
						"yaml",
					},
				})
			end,
		},
	}
end
