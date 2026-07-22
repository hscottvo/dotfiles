{ pkgs, inputs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  home.username = "scott";
  home.homeDirectory = "/Users/scott";

  home.packages = with pkgs; [
    discord
    git
    keychain
    xclip
    p7zip
    hoppscotch
    stow

    just
    nix-direnv
    openssl
    pkgconf
  ];
  programs.zen-browser = {
    enable = true;
    darwinDefaultsId = "app.zen-browser.zen";
    profiles = {
      main = { };
    };
  };
  stylix.targets.zen-browser.profileNames = [ "main" ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;
}
