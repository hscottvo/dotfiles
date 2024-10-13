{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    discord
    musescore
    obs-studio
    spotify
    vlc

    vesktop
  ];
}

