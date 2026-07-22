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

  # Modules every home configuration gets, regardless of platform.
  globalModules = [
    hm.global-base
    hm.global-apps
    hm.global-shell
    hm.global-nvim
    hm.global-colors
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
