{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Requirements for Neovim
    fd
    gcc
    gnumake
    lazygit
    lua
    luajitPackages.luarocks_bootstrap
    nodejs_22
    python3
    ripgrep
    tree-sitter

    # lua (dotfiles)
    lua-language-server
    stylua

    # markdown
    marksman
    rumdl
    markdownlint-cli2
    prettierd

    # nix (dotfiles)
    nixfmt

    # toml
    taplo

    unzip
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  stylix.targets.neovim.enable = false;

  programs.yazi = {
    enable = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
