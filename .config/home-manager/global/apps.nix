{ pkgs, ... }:

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
    profiles.main = {
      isDefault = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "media.peerconnection.enabled" = true;
        "gfx.webrender.all" = true;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.sessions" = false;
      };
    };
  };

  stylix.targets.librewolf.profileNames = [ "main" ];
}

