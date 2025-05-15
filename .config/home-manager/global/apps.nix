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
      spotify
      spotify-player
      tree
    ];

  programs.btop = {
    enable = true;
  };

  programs.librewolf = {
    enable = true;
    profiles = {
      main = { };
    };
    settings = { "privacy.resistFingerprinting" = true; };
  };
  stylix.targets.librewolf.profileNames = [ "main" ];

}

