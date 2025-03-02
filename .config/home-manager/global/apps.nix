{ config, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      brave
      hunspell
      dbeaver-bin
      duckdb
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

