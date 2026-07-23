{ self, inputs, ... }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    stylix
    mac-app-util
    ;
  hm = self.homeModules;

  pkgsFor =
    system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  # Put the repo's own `drift` CLI on PATH (source in ../../drift, packaged in
  # ../packages/drift.nix). Each machine's role/host for it is written to
  # ~/.config/drift/config.toml by the mac-*/linux-base modules.
  driftOnPath =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.drift ];
    };

  # Modules every home configuration gets, regardless of platform.
  globalModules = [
    hm.global-base
    hm.global-apps
    hm.global-shell
    hm.global-nvim
    hm.global-colors
    driftOnPath
    stylix.homeModules.stylix
  ];

  # Both Macs share global + mac-base; each adds its role module.
  # Build with: home-manager switch --flake ~/dotfiles#scott-mac-personal (or -work).
  mkMac =
    roleModules:
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor "aarch64-darwin";
      modules =
        globalModules
        ++ [
          hm.mac-base
          mac-app-util.homeManagerModules.default
        ]
        ++ roleModules;
      extraSpecialArgs = { inherit inputs; };
    };
in
{
  flake.homeConfigurations = {
    # Build with: home-manager switch --flake ~/dotfiles#scott-linux
    scott-linux = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor "x86_64-linux";
      modules = globalModules ++ [
        hm.linux-base
        hm.linux-desktop
        hm.linux-apps
        hm.linux-games
        hm.linux-nvim
      ];
      extraSpecialArgs = { inherit inputs; };
    };

    scott-mac-personal = mkMac [ hm.mac-personal ];
    scott-mac-work = mkMac [ hm.mac-work ];
  };
}
