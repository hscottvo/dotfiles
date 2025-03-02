{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    obs-studio
    nginx
    vlc
    vesktop
  ];
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,window";
      # modi = "drun,window";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
      # };
    };
  };



}

