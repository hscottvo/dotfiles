{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Requirements for Neovim
    cargo
    fd
    gcc
    gnumake
    lazygit
    lua
    luajitPackages.luarocks_bootstrap
    nodejs_22
    python3
    ripgrep
    rustc
    tree-sitter

    # bash
    bash-language-server

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

    # rust
    rustfmt
    rust-analyzer

    # toml
    taplo

    # terraform
    terraform
    terraform-ls
    tflint

    # typescript
    eslint
    eslint_d
    typescript-language-server
    # vimPlugins.coc-tsserver

    # YAML
    yaml-language-server

    unzip
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };


}

