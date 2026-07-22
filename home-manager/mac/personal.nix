{ ... }:

{
  programs.zsh.shellAliases = {
    dr = "sudo darwin-rebuild --impure switch --flake ~/dotfiles/darwin#personal --option warn-dirty false";
    hms = "home-manager switch --flake ~/dotfiles/home-manager#scott-mac-personal --option warn-dirty false";
  };
}
