{
  # Work-laptop-only tooling. Homebrew casks merge across modules, so these
  # append to the shared list in ./common.nix. Only the `work` darwin
  # configuration pulls this in.
  flake.darwinModules.work = {
    homebrew.casks = [
      "tsh"
      "1password-cli"
      "gcloud-cli"
    ];
  };
}
