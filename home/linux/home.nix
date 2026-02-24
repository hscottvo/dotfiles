{ pkgs, ... }:

{
  home.username = "scott";
  home.homeDirectory = "/home/scott";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    git
    keychain
    xclip
    p7zip
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  programs.home-manager.enable = true;
}
