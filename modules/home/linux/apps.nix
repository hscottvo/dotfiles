{
  # Linux GUI apps, the Zen browser, and the fuzzel launcher (themed from the
  # everforest palette). The colors options come from global-colors, which
  # every home configuration includes, so no direct import is needed.
  flake.homeModules.linux-apps =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    let
      colors = config.custom.themes.everforest.colors;
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];
      home.packages = with pkgs; [
        cliphist
        obs-studio
        libreoffice-qt
        nginx
        signal-desktop
        vlc
        vesktop
        wl-clipboard
      ];

      programs.zen-browser = {
        enable = true;
        profiles = {
          main = { };
        };
      };
      stylix.targets.zen-browser.profileNames = [ "main" ];

      programs.fuzzel = {
        enable = true;
        settings = {
          colors = {
            background = "${colors.bg_dim}FF";
            text = "${colors.fg}FF";
            prompt = "${colors.grey1}FF";
            selection = "${colors.grey1}FF";
            selection-text = "${colors.bg_dim}FF";
            border = "${colors.green}FF";
          };
          main = {
            horizontal-pad = 10;
            vertical-pad = 5;
            font = "FiraCode:size=16";
            use-bold = true;
            placeholder = "Select an app...";
          };
          border.width = 2;
        };
      };
      stylix.targets.fuzzel.enable = false;
    };
}
