{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    obs-studio
    vlc
    vesktop
  ];

}

