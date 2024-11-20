{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    google-chrome
    dunst
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


    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })

  ];

  gtk = with pkgs; {
    enable = true;
    # theme.name = "gruvbox-dark";
    # theme.package = gruvbox-dark-gtk;
    theme.name = "Nordic";
    theme.package = nordic;

    iconTheme.name = "";
    iconTheme.package = arc-icon-theme;
  };

  wayland.windowManager.hyprland.xwayland.enable = true;

}

