{ pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Display manager
  services.displayManager.sddm.enable = true;

  # Desktop environment
  services.xserver.desktopManager.gnome.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.xwayland.enable = true;

  # Niri
  programs.niri.enable = true;

  # XDG portals
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
      ];
      xdgOpenUsePortal = true;
    };
  };

  # Flatpak
  services.flatpak.enable = true;

  # Printing
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.browsedConf = ''
    BrowseDNSSDSubTypes _cups,_print
    BrowseLocalProtocols all
    BrowseRemoteProtocols all
    CreateIPPPrinterQueues All

    BrowseProtocols all
  '';
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = "true";
      };
    };
  };
}
