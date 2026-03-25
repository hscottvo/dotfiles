# Language DevShells

Per-language nix devShells. Use these to get LSPs and tooling in projects without modifying their flakes.

## How direnv works

[direnv](https://direnv.net) watches for `.envrc` files and loads/unloads environment variables as you `cd` in and out of directories. With `nix-direnv`, `use flake <path>` drops you into a nix devShell automatically.

You need to allow a new `.envrc` once with `direnv allow` before it activates.

## Gitignore note

`devenv.local.nix` and `.local/` are in the global gitignore via home-manager (`programs.git.ignores` in `global/shell.nix`). If you're on a machine not using this home-manager config, add them manually to `~/.config/git/ignore`.

## Usage

### Projects with a plain flake

Stack language shells on top of the project's own devShell, or use one standalone:

```bash
# .envrc
use flake .                              # project's devShell
use flake ~/dotfiles/languages/rust      # your tools on top
```

You'll need to create this `.envrc` yourself and run `direnv allow`.

### Projects with devenv — `.local/dev.envrc` pattern

Some team repos (e.g. imogen-verify, imogen-web) explicitly source `.local/dev.envrc` in their `.envrc`:

```bash
source_env_if_exists $LOCAL/dev.envrc
```

If the repo has this, just drop your additions there — no `direnv allow` needed:

```bash
# .local/dev.envrc
use flake ~/dotfiles/languages/elixir
```

Check the repo's `.envrc` to confirm it has this pattern before relying on it.

### Projects with devenv — `devenv.local.nix`

For devenv repos that don't have the `.local/dev.envrc` pattern, use `devenv.local.nix` instead. devenv merges this automatically:

```nix
# devenv.local.nix
{ pkgs, ... }: {
  packages = with pkgs; [
    elixir
    elixir-ls
  ];
}
```

### Do you need devenv?

No. Plain flakes + `use flake` work fine for LSPs and tooling. devenv is worth it when you need services (postgres, kafka) or process management (`devenv up`). For personal additions, plain flakes are simpler.

## Available languages

| Directory    | Packages                                                            |
| ------------ | ------------------------------------------------------------------- |
| `rust`       | cargo, clippy, rustc, rustfmt, rust-analyzer, bacon                 |
| `go`         | go, gopls                                                           |
| `elixir`     | elixir, elixir-ls                                                   |
| `python`     | python3, black, isort, pyright, ruff                                |
| `typescript` | nodejs, typescript, typescript-language-server, eslint_d, prettierd |
| `terraform`  | terraform, terraform-ls, tflint                                     |
| `cpp`        | clang-tools                                                         |
| `bash`       | bash-language-server, shfmt                                         |
