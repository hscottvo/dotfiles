{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    waybar
    wlogout
  ];

  wayland.windowManager.hyprland.xwayland.enable = true;
}
