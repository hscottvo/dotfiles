{ config, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      brave
      musescore
      obsidian
      signal-desktop
      spotify
      spotify-player
      tree
    ];

  programs.btop = {
    enable = true;
  };

}

