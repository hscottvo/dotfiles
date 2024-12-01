{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    google-chrome
    rofi
    fastfetch
    flatpak
    nwg-look
    pavucontrol
    waybar
    wlogout
    xfce.thunar
    xfce.thunar-volman

    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    wl-clipboard



  ];

  services.dunst = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "frappe";
    };
    settings = {

      global = {
        font = "FiraCode Mono 14";
        width = 400;

      };
    };
  };

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "frappe";
      icon.enable = true;
    };
  };

  wayland.windowManager.hyprland.xwayland.enable = true;

}

