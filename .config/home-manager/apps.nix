{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    discord
    (if system == "aarch64-darwin" then null else obs-studio)
    spotify
    vlc

    # vesktop
  ];
}

