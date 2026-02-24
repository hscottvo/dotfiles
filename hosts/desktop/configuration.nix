{ config, pkgs, ... }:

{
  # Hostname
  networking.hostName = "desktop";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # GameCube adapter kernel module
  boot.extraModulePackages = [
    config.boot.kernelPackages.gcadapter-oc-kmod
  ];
  boot.kernelModules = [ "gcadapter_oc" ];

  # Filesystem settings
  boot.supportedFilesystems = [ "fuse" ];
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # User configuration
  users.users.scott = {
    isNormalUser = true;
    initialPassword = "12345";
    description = "main user";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      appimage-run
      fuse
      dolphin-emu
      vim
      firefox
      git
      ghostty
      kitty
      networkmanagerapplet
      stow
    ];
  };

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;

  # Enable Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # KDE Connect
  programs.kdeconnect.enable = true;

  # QMK
  hardware.keyboard.qmk.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    slippi-launcher
    qmk
  ];

  # Stylix (for theming)
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };

  # State version
  system.stateVersion = "24.05";
}
