{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    discord
    musescore
    obs-studio
    signal-desktop
    spotify
    tree
    vlc

    vesktop
  ];
}

