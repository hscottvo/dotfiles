{ pkgs, ... }:

{
  home.username = "scott";
  home.homeDirectory = "/Users/scott";

  home.packages = with pkgs; [
    discord
    git
    keychain
    xclip
    p7zip
    hoppscotch
    stow

    just
    nix-direnv
    openssl
    pkgconf
    _1password-cli
  ];

  programs.zsh.shellAliases = {
    dr = "sudo darwin-rebuild --impure switch --flake ~/dotfiles/darwin#main --option warn-dirty false";
    hms = "home-manager switch --flake ~/dotfiles/home-manager#scott-mac --option warn-dirty false";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;
}
