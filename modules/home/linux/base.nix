{
  # Linux home base: username/homedir, core packages, and rebuild aliases
  # against the unified flake (#scott-linux for home, #main for the system).
  flake.homeModules.linux-base =
    { pkgs, ... }:
    {
      home.username = "scott";
      home.homeDirectory = "/home/scott";

      home.packages = with pkgs; [
        git
        keychain
        xclip
        p7zip
      ];
      programs.ghostty.enable = true;

      programs.zsh.shellAliases = {
        hms = "home-manager switch --flake ~/dotfiles#scott-linux --option warn-dirty false";
        nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#main --option warn-dirty false";
      };

      # Tell drift which NixOS host this is (see modules/packages/drift.nix).
      xdg.configFile."drift/config.toml".text = ''
        nixos_host = "main"
      '';

      home.sessionPath = [ "$HOME/.local/bin" ];
      programs.home-manager.enable = true;
    };
}
