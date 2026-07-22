{
  # Personal Mac role. `dr` rebuilds the system, `hms` the home config, both
  # against the unified flake (#personal / #scott-mac-personal).
  flake.homeModules.mac-personal =
    { ... }:
    {
      programs.zsh.shellAliases = {
        dr = "sudo darwin-rebuild --impure switch --flake ~/dotfiles#personal --option warn-dirty false";
        hms = "home-manager switch --flake ~/dotfiles#scott-mac-personal --option warn-dirty false";
      };
    };
}
