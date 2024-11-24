{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    musescore
    obsidian
    signal-desktop
    spotify
    spotify-player
    tree
  ];

}

