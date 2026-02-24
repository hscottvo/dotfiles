{ pkgs, ... }:

{
  # System packages available to all darwin hosts
  environment.systemPackages = with pkgs; [
    rustup
    stow
    vim
  ];

  # Disable nix daemon (as in your current config)
  nix.enable = false;

  # Nix settings
  nix.settings.experimental-features = "nix-command flakes";
}
