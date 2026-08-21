{
  flake.homeModules.global-zen =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = lib.mkMerge [
        {
          enable = true;
          setAsDefaultBrowser = true;
          policies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DontCheckDefaultBrowser = true;
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
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
                "uBlock0@raymondhill.net" = fromAmo "ublock-origin";
                "vimium-c@gdh1995.cn".installation_mode = "blocked";
                "@testpilot-containers" = fromAmo "multi-account-containers";
                "amptra@keepa.com" = fromAmo "keepa";
              };
          };
          profiles.main = {
            settings = {
              "zen.welcome-screen.seen" = true;
              "security.webauthn.ctap2" = false;
            };
            presets.betterfox.enable = true;
          };
        }
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          darwinDefaultsId = "app.zen-browser.zen";
        })
      ];

      stylix.targets.zen-browser = {
        enable = true;
        profileNames = [ "main" ];
      };
    };
}
