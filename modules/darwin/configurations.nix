{ self, inputs, ... }:
let
  # Both Macs share common.nix; each adds its role modules on top.
  # Build with: darwin-rebuild switch --flake ~/dotfiles#personal (or #work).
  darwinSystem =
    extraModules:
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        inputs.mac-app-util.darwinModules.default
        self.darwinModules.common
      ]
      ++ extraModules;
    };
in
{
  flake.darwinConfigurations.personal = darwinSystem [ ];
  flake.darwinConfigurations.work = darwinSystem [ self.darwinModules.work ];

  # Expose the package set (with overlays) for convenience.
  flake.darwinPackages = self.darwinConfigurations.personal.pkgs;
}
