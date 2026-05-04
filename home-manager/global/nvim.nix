{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Requirements for Neovim
    fd
    gcc
    gnumake
    lazygit
    lua
    luajitPackages.luarocks_bootstrap
    neovim
    nodejs_22
    python3
    ripgrep
    tree-sitter

    # bash
    bash-language-server
    shfmt

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

  home.activation.nvimSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -L ~/.config/nvim ] || [ -d ~/.config/nvim ]; then
      rm -rf ~/.config/nvim
    fi

    ln -s ~/dotfiles/nvim ~/.config/nvim
  '';
  stylix.targets.neovim.enable = false;

  programs.yazi = {
    enable = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
