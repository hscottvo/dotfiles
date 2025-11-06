{ pkgs, ... }:

{
  home.username = "scott";
  home.homeDirectory = "/Users/scott";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    discord
    git
    keychain
    xclip
    p7zip
    hoppscotch
    stow

  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.home-manager.enable = true;
}
