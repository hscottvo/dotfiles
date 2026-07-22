{
  # Hyprland desktop. Registered for discoverability but NOT wired into the
  # linux home configuration (niri is the active compositor). To use it, add
  # self.homeModules.linux-hyprland to the scott-linux modules list in
  # ../configurations.nix.
  flake.homeModules.linux-hyprland =
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
    };
}
