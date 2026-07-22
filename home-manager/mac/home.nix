{ pkgs, inputs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  home.username = "scott";
  home.homeDirectory = "/Users/scott";

  home.packages = with pkgs; [
    discord
    git
    keychain
    xclip
    p7zip
    hoppscotch
    stow

    just
    nix-direnv
    openssl
    pkgconf
  ];
  programs.zen-browser = {
    enable = true;
    darwinDefaultsId = "app.zen-browser.zen";
    setAsDefaultBrowser = true;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false; # Bitwarden handles logins
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      # home-manager owns profiles.ini as a read-only symlink, so Firefox's
      # multi-profile selector can't write to it. Disable it and boot straight
      # into the declared profile.
      Preferences."browser.profiles.enabled" = {
        Value = false;
        Status = "locked";
      };
      ExtensionSettings =
        let
          fromAmo = pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          };
        in
        {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = fromAmo "bitwarden-password-manager";
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = fromAmo "vimium-ff";
          "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = fromAmo "hide-youtube-shorts";
          "keepa" = fromAmo "keepa";
          # AdNauseam (uBlock Origin fork): blocks ads + clicks them invisibly to
          # pollute tracking profiles. Don't add uBlock Origin alongside it.
          "adnauseam@rednoise.org" = fromAmo "adnauseam";
          "vimium-c@gdh1995.cn".installation_mode = "blocked";
        };
    };

    profiles.main = {
      settings = {
        "zen.welcome-screen.seen" = true;
      };
      # Sane privacy/telemetry/perf hardening that keeps history + cookies and
      # doesn't break sites (unlike the aggressive arkenfox preset).
      presets.betterfox.enable = true;
    };
  };
  stylix.targets.zen-browser.profileNames = [ "main" ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;
}
