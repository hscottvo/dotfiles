{
  # Work Mac role. Extra packages plus rebuild aliases against the unified
  # flake (#work / #scott-mac-work).
  flake.homeModules.mac-work =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        _1password-cli
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

      # greywall sandbox (mo-pi): wrap pi in the company deny-by-default OS sandbox.
      # Work mac only — this file is not imported by scott-mac-personal. Guarded on
      # the binary by absolute path, so it is a harmless no-op if greywall is not
      # installed and immune to PATH-ordering during shell startup.
      #   pi       → sandboxed (greywall --profile pi,mo -- pi)
      #   pi-bare  → raw pi, for `pi install` / `pi update` (npm registry is blocked
      #              inside the sandbox)
      programs.zsh.initContent = ''
        if [ -x "$HOME/.local/bin/greywall" ]; then
          alias pi='greywall --profile pi,mo -- pi'
        fi
        alias pi-bare='command pi'
      '';
    };
}
