{
  # Work Mac role. Extra packages plus rebuild aliases against the unified
  # flake (#work / #scott-mac-work).
  flake.homeModules.mac-work = { pkgs, ... }: {
    home.packages = with pkgs; [
      _1password-cli
      docker-credential-helpers
      ntfy-sh
    ];

    programs.zsh.shellAliases = {
      dr = "sudo darwin-rebuild --impure switch --flake ~/dotfiles#work --option warn-dirty false";
      hms = "home-manager switch --flake ~/dotfiles#scott-mac-work --option warn-dirty false";
    };

    # Tell drift which Mac this is (see modules/packages/drift.nix).
    xdg.configFile."drift/config.toml".text = ''
      role = "work"
    '';
  };
}
