{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    blueman
    dunst
    rofi
    fastfetch
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
    theme.name = "gruvbox-dark";
    theme.package = gruvbox-dark-gtk;

    iconTheme.name = "";
    iconTheme.package = arc-icon-theme;
  };

  wayland.windowManager.hyprland.xwayland.enable = true;

}

