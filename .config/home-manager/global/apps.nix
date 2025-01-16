{ config, pkgs, ... }:

{
  home.packages = with pkgs;
    [
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

