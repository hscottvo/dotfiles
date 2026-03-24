{ pkgs, ... }:

{
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  home.packages = with pkgs; [
    git
    keychain
    xclip
    p7zip
  ];
  programs.ghostty.enable = true;

  programs.zsh.shellAliases = {
    hms = "home-manager switch --flake ~/dotfiles/home-manager#scott-linux --option warn-dirty false";
    nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos#main --option warn-dirty false";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
  programs.home-manager.enable = true;
}
