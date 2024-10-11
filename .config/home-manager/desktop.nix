{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay  # Add cowsay to your environment
    rofi
    fastfetch
    nwg-look
    waybar
    wlogout
    xfce.thunar
    xfce.thunar-volman

    hyprcursor
    hypridle
    hyprpaper
    hyprlock
    wl-clipboard


    (nerdfonts.override {fonts = [ "Iosevka" "JetBrainsMono" ]; })

  ];

  gtk = with pkgs; {
    enable = true;
    theme.name = "gruvbox-dark";
    theme.package = gruvbox-dark-gtk;

    iconTheme.name = "";
    iconTheme.package = arc-icon-theme;
  };


}

