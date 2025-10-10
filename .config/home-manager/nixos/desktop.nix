{ pkgs, ... }:

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

  services.swaync.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  wayland.windowManager.hyprland.xwayland.enable = true;

}

