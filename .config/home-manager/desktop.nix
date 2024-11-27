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


    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })

  ];

  gtk = with pkgs; {
  services.dunst = {
    enable = true;
    # theme.name = "gruvbox-dark";
    # theme.package = gruvbox-dark-gtk;
    theme.name = "Nordic";
    theme.package = nordic;
    catppuccin = {
      enable = true;
      flavor = "frappe";
    };
    settings = {

    iconTheme.name = "";
    iconTheme.package = arc-icon-theme;
      global = {
        font = "FiraCode Mono 14";
        width = 400;

      };
    };
  };

  wayland.windowManager.hyprland.xwayland.enable = true;

}

