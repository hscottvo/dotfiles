{
  description = "Home Manager configuration of scott";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }:
    let
      moduleFiles = [ ./global/apps.nix ./games.nix ./global/nvim.nix ./global/shell.nix catppuccin.homeManagerModules.catppuccin ];
      linuxFiles = [ ./nixos/home.nix ./desktop.nix ./nixos/apps.nix ];
      macFiles = [ ./mac/home.nix ];
    in
    {

      homeConfigurations.scott-linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = moduleFiles ++ linuxFiles;
      };

      homeConfigurations.scott-mac = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = moduleFiles ++ macFiles;
      };

    };
}
