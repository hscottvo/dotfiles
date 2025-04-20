{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            rustup
            stow
            vim
            signal-desktop
          ];
        homebrew = {
          enable = true;
          brews = [ "sdl3" ];
          casks = [ "ghostty" "signal" "vlc" ];
        };

        # Auto upgrade nix package and the daemon service.
        # services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;
        services.aerospace = {

          enable = true;
          settings = {
            gaps = {
              outer.left = 8;
              outer.bottom = 8;
              outer.top = 8;
              outer.right = 8;
            };
            mode.main.binding = {
              alt-h = "focus left";
              alt-j = "focus down";
              alt-k = "focus up";
              alt-l = "focus right";

              alt-1 = "workspace --auto-back-and-forth 1";
              alt-2 = "workspace --auto-back-and-forth 2";
              alt-3 = "workspace --auto-back-and-forth 3";
              alt-4 = "workspace --auto-back-and-forth 4";
              alt-5 = "workspace --auto-back-and-forth 5";
              alt-6 = "workspace --auto-back-and-forth 6";
              alt-7 = "workspace --auto-back-and-forth 7";
              alt-8 = "workspace --auto-back-and-forth 8";
              alt-9 = "workspace --auto-back-and-forth 9";

              alt-shift-1 = "move-node-to-workspace 1";
              alt-shift-2 = "move-node-to-workspace 2";
              alt-shift-3 = "move-node-to-workspace 3";
              alt-shift-4 = "move-node-to-workspace 4";
              alt-shift-5 = "move-node-to-workspace 5";
              alt-shift-6 = "move-node-to-workspace 6";
              alt-shift-7 = "move-node-to-workspace 7";
              alt-shift-8 = "move-node-to-workspace 8";
              alt-shift-9 = "move-node-to-workspace 9";
            };
          };
        };

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
      darwinConfigurations.Scotts-Macbook-Pro = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.scott.pkgs;
    };
}
