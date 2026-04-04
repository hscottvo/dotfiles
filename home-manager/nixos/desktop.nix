{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    blueman
    google-chrome
    fastfetch
    flatpak
    gparted
    nwg-look
    pavucontrol
    wl-clipboard
    xfce.thunar
    xfce.thunar-volman
  ];

  services.swaync.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  # TODO: When niri config is stable, switch to nix-generated config for theming:
  #   xdg.configFile."niri/config.kdl".text =
  #     builtins.readFile ../../niri/config.kdl
  #     + ''
  #       // nix-generated colors from colors.nix (focus-ring, border, etc.)
  #     '';
  # See starship config in shell.nix for the pattern.
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "/home/scott/dotfiles/niri/config.kdl";

}
