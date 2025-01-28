{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Requirements for Neovim
    cargo
    fd
    gcc
    gnumake
    lazygit
    libgcc
    lua
    luajitPackages.luarocks_bootstrap
    nodejs_22
    python3
    ripgrep
    rustc
    tree-sitter

    # cpp
    clang-tools

    # go
    go
    gopls
    # lua
    lua-language-server
    stylua

    # markdown
    marksman
    markdownlint-cli2
    nodePackages.prettier


    # nix
    nil
    nixpkgs-fmt

    # python
    black
    isort
    pyright

    # terraform
    terraform
    terraform-ls
    tflint

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

