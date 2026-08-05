{
  # Shared mac home config (both personal and work): username/homedir, mac
  # packages, and the Zen browser. Role modules (mac-personal / mac-work) add
  # the rebuild aliases and role-specific packages.
  flake.homeModules.mac-base =
    { pkgs, inputs, ... }:
    {
      home.username = "scott";
      home.homeDirectory = "/Users/scott";

      home.packages = with pkgs; [
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

      home.sessionPath = [ "$HOME/.local/bin" ];

      programs.home-manager.enable = true;
    };
}
