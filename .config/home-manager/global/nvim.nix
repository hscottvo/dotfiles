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

    # prettier
    prettierd

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
    typescript
    typescript-language-server
    vscode-langservers-extracted

    # vue
    vue-language-server

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

