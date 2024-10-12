{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    discord
    obs-studio
    spotify
    vlc

    # vesktop
  ];
}

