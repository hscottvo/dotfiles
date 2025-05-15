{
  description = "Home Manager configuration of scott";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { nixpkgs, home-manager, zen-browser, stylix, ... } @ inputs:
    let
      moduleFiles = [
        ./global/apps.nix
        ./global/nvim.nix
        ./global/shell.nix
        ./global/colors.nix
        stylix.homeManagerModules.stylix
      ];
      linuxFiles = [
        ./nixos/home.nix
        ./nixos/desktop.nix
        ./nixos/apps.nix
        ./nixos/games.nix
        ./nixos/nvim.nix
      ];
      macFiles = [
        ./mac/home.nix
      ];
    in
    {

      homeConfigurations.scott-linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        modules = moduleFiles ++ linuxFiles;
        extraSpecialArgs = { inherit inputs; };
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
