{
  # Work-laptop-only tooling. Homebrew casks merge across modules, so these
  # append to the shared list in ./common.nix. Only the `work` darwin
  # configuration pulls this in.
  flake.darwinModules.personal = {
    homebrew.taps = [ "BarutSRB/tap" ];

    homebrew.casks = [
      "discord"
      "omniwm"
    ];

    # OmniWM requires "Displays have separate Spaces".
    system.defaults.spaces.spans-displays = false;
  };
}
