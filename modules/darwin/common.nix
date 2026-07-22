{ self, ... }:
{
  # Shared nix-darwin config for both Macs. Role-specific bits (work casks)
  # live in ./work.nix; the two are combined in ./configurations.nix.
  flake.darwinModules.common =
    { pkgs, ... }:
    {
      system.primaryUser = "scott";
      environment.systemPackages = with pkgs; [
        rustup
        stow
        vim
      ];

      environment.systemPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        casks = [
          "finetune"
          "ghostty"
          "maccy"
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

      # nix-darwin does not manage the Nix installation (Determinate Nix owns it).
      nix.enable = false;
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Read the changelog before changing (`darwin-rebuild changelog`).
      system.stateVersion = 5;

      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
    };
}
