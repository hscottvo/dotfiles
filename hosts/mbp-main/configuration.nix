{ pkgs, config, ... }:

{
  # Set hostname
  networking.hostName = "mbp-main";
  networking.computerName = "mbp-main";

  # Primary user
  system.primaryUser = "scott";

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this system
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version
  system.configurationRevision = null;

  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
