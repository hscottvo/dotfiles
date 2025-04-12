{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    obs-studio
    libreoffice-qt
    librewolf
    nginx
    vlc
    vesktop
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      colors = {
        background = "1E2326FF";
        text = "D3C6AAFF";
        prompt = "859289FF";
        selection = "859289FF";
        selection-text = "1E2326FF";
        border = "A7C080FF";
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
}

