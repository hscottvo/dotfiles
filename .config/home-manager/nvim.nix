{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Requirements for Neovim
    cargo
    gcc
    go
    gnumake
    lazygit
    libgcc
    lua
    luajitPackages.luarocks_bootstrap
    nodejs_22
    python3
    ripgrep
    rustc

    # cpp
    clang-tools

    # lua
    lua-language-server
    stylua

    # nix
    nil
    nixpkgs-fmt

    # python
    black
    isort
    pyright

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

