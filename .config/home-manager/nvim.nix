{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
	cargo
	gcc
	go
	gnumake
	lazygit
	libgcc
    lua
	luajitPackages.luarocks_bootstrap
	nodejs_22
	pyright
	python3
	ripgrep
	rustc

    unzip
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
	plugins = with pkgs.vimPlugins; [
	  mason-nvim
	  nvim-lspconfig
	  mason-lspconfig-nvim
	  gruvbox-material-nvim
	];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };


}

