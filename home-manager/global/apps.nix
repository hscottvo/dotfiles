{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    policies = {
      ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };

        "vimium-c@gdh1995.cn" = {
          installation_mode = "blocked";
        };
        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/hide-youtube-shorts/latest.xpi";
          installation_mode = "force_installed";
        };
        "keepa" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepa/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
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
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  stylix.targets.librewolf.profileNames = [ "main" ];
}
