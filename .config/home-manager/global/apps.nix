{ config, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      brave
      libreoffice-qt
      hunspell
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

