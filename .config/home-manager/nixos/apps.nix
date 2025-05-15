{ config, pkgs, inputs, ... }:

let
  colors = config.custom.themes.everforest.colors;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ../global/colors.nix
  ];
  home.packages = with pkgs; [
    obs-studio
    libreoffice-qt
    nginx
    signal-desktop
    vlc
    vesktop
  ];

  programs.zen-browser = {
    enable = true;
    profiles = {
      main = { };
    };
  };

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
}

