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

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  programs.home-manager.enable = true;
}
