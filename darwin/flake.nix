{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util }:
    let
      configuration = { pkgs, config, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        system.primaryUser = "scott";
        environment.systemPackages = with pkgs;
          [
            rustup
            stow
            vim
          ];
        homebrew = {
          enable = true;
          brews = [ "sdl3" ];
          casks = [ "ghostty" "signal" "vlc" "qbittorrent" ];
        };

        nix.enable = false;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # # fix spotlight
        # system.activationScripts.applications.text =
        #   let
        #     env = pkgs.buildEnv {
        #       name = "system-applications";
        #       paths = config.environment.systemPackages;
        #       pathsToLink = "/Applications";
        #     };
        #   in
        #   pkgs.lib.mkForce ''
        #     # Set up applications.
        #     echo "setting up /Applications..." >&2
        #     rm -rf /Applications/Nix\ Apps
        #     mkdir -p /Applications/Nix\ Apps
        #     find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        #     while read -r src; do
        #       app_name=$(basename "$src")
        #       echo "copying $src" >&2
        #       ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        #     done
        #   '';

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.Scotts-Macbook-Pro = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
          configuration
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.scott.pkgs;
    };
}

# home-manager.darwinModules.home-manager
# {
#   home-manager.useGlobalPkgs = true;
#   home-manager.useUserPackages = true;
# }
