# dotfiles

One Nix flake drives every machine: NixOS, both Macs (nix-darwin), and the
home-manager configs for each. It uses the **dendritic pattern** — every `.nix`
file under `modules/` is a [flake-parts](https://flake.parts) module, and
[`import-tree`](https://github.com/vic/import-tree) loads all of them
automatically. There is no central list of imports to maintain: to add config,
drop a new file in the right directory and rebuild.

## Rebuild commands

The `dr` / `hms` / `nrs` shell aliases wrap these (see
`modules/home/*/base.nix`):

```sh
# NixOS system
sudo nixos-rebuild switch --flake ~/dotfiles#main

# Macs (system)
sudo darwin-rebuild switch --flake ~/dotfiles#personal   # personal Mac
sudo darwin-rebuild switch --flake ~/dotfiles#work        # work Mac

# home-manager
home-manager switch --flake ~/dotfiles#scott-linux
home-manager switch --flake ~/dotfiles#scott-mac-personal
home-manager switch --flake ~/dotfiles#scott-mac-work

nix flake update      # bump every input (single flake.lock); alias: bump-locks
nix fmt modules        # format Nix files (nixfmt)
```

## Layout

```
flake.nix                 inputs (declared once) + import-tree ./modules
modules/
  flake/
    systems.nix           systems list + `nix fmt` formatter
    devshell.nix          `nix develop` shell (repo tooling)
    module-registries.nix declares flake.darwinModules / flake.homeModules
  darwin/
    common.nix            shared nix-darwin config  -> flake.darwinModules.common
    work.nix              work-only casks           -> flake.darwinModules.work
    configurations.nix    -> flake.darwinConfigurations.{personal,work}
  home/
    global/               cross-platform home modules -> flake.homeModules.global-*
    mac/                  mac base + role modules     -> flake.homeModules.mac-*
    linux/                linux modules               -> flake.homeModules.linux-*
    configurations.nix    -> flake.homeConfigurations.{scott-linux,scott-mac-*}
  nixos/
    features/             reusable NixOS modules      -> flake.nixosModules.*
    hosts/main/           the `main` host             -> flake.nixosConfigurations.main
languages/                per-project `nix develop` shells (separate flakes)
```

## How the wiring works

A leaf file registers a module into a namespace, e.g.:

```nix
{
  flake.homeModules.global-apps =
    { pkgs, ... }:
    { home.packages = [ pkgs.tree ]; };
}
```

A `configurations.nix` file then assembles those registered modules into an
actual system/home configuration by referencing `self.homeModules.<name>` (or
`self.darwinModules.<name>`). Because the home configs are split by platform,
the module list in `modules/home/configurations.nix` is explicit: global
modules go everywhere, `mac-*` only to the Macs, `linux-*` only to NixOS.

`flake.nixosModules` is a mergeable registry that flake-parts declares out of
the box; `flake.darwinModules` and `flake.homeModules` are declared the same
way in `modules/flake/module-registries.nix` so multiple files can register
into them.

## Theming

Stylix drives the system palette (Catppuccin Macchiato) from
`modules/home/global/base.nix`. An Everforest palette is also exposed as
home-manager options in `modules/home/global/colors.nix` for modules that read
named colors directly (e.g. the fuzzel launcher).

GTK theme: https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme
