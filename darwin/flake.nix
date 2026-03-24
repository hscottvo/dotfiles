{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      mac-app-util,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          system.primaryUser = "scott";
          environment.systemPackages = with pkgs; [
            rustup
            stow
            vim
          ];
          homebrew = {
            enable = true;
            casks = [
              "ghostty"
              "1password-cli"
            ];
          };

          system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
          system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
          system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 1.5;
          system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
          system.defaults.NSGlobalDomain.KeyRepeat = 2;
          system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
          system.defaults.dock.tilesize = 48;
          system.defaults.dock.orientation = "right";
          system.defaults.dock.show-recents = false;
          system.defaults.dock.wvous-br-corner = 1;
          system.defaults.finder.FXPreferredViewStyle = "Nlsv";
          system.defaults.finder.ShowExternalHardDrivesOnDesktop = true;
          system.defaults.finder.ShowRemovableMediaOnDesktop = true;
          system.defaults.finder.AppleShowAllExtensions = true;
          system.defaults.finder.ShowPathbar = true;
          system.defaults.WindowManager.EnableTiledWindowMargins = false;
          system.defaults.WindowManager.HideDesktop = false;
          system.defaults.trackpad.Clicking = false;
          system.defaults.menuExtraClock.ShowAMPM = true;
          system.defaults.menuExtraClock.ShowDate = 0;
          system.defaults.menuExtraClock.ShowDayOfWeek = true;
          system.defaults.screensaver.askForPasswordDelay = 5;

          nix.enable = false;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          # programs.fish.enable = true;

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
      darwinConfigurations.main = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
          configuration
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.main.pkgs;
    };
}

# home-manager.darwinModules.home-manager
# {
#   home-manager.useGlobalPkgs = true;
#   home-manager.useUserPackages = true;
# }
