{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    google-chrome
    # rofi
    fastfetch
    flatpak
    gparted
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
    settings = {

      global = {
        font = "FiraCode Mono 14";
        width = 400;

      };
    };
  };
  services.swaync.enable = true;

  gtk = {
    enable = true;
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Nordic";
    };
    iconTheme = {
      # package = pkgs.papirus-nord;
      # name = "Papirus-Nord";
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  wayland.windowManager.hyprland.xwayland.enable = true;

}

