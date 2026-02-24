{
  description = "Unified Nix configuration for NixOS and Darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-specific inputs
    ssbm-nix = {
      url = "github:NormalFall/ssbm-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    # Temporarily commented out for darwin testing
    # mac-app-util = {
    #   url = "github:hraban/mac-app-util";
    #   inputs.cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
    # };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ssbm-nix, stylix, ... }@inputs:
    {
      # macOS configuration
      darwinConfigurations.mbp-main = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          # Host configuration
          ./hosts/mbp-main/configuration.nix

          # Darwin modules
          ./modules/darwin/common.nix
          ./modules/darwin/homebrew.nix

          # Home Manager - temporarily disabled for testing
          # home-manager.darwinModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.scott = {
          #     home.username = "scott";
          #     home.homeDirectory = "/Users/scott";
          #     home.stateVersion = "24.05";
          #     programs.home-manager.enable = true;
          #   };
          # }
        ];
      };

      # NixOS configuration
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Host configuration
          ./hosts/desktop/configuration.nix
          ./hosts/desktop/hardware-configuration.nix

          # NixOS modules
          ./modules/nixos/common.nix
          ./modules/nixos/desktop.nix
          ./modules/nixos/nvidia.nix
          ./modules/nixos/audio.nix
          ./modules/nixos/games.nix

          # Shared modules
          ./modules/shared/fonts.nix

          # Stylix
          stylix.nixosModules.stylix

          # SSBM overlay
          inputs.ssbm-nix.overlay

          # Home Manager - TODO: wire this up properly
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.scott = import ./home/linux/home.nix;
          # }
        ];
      };
    };
}
