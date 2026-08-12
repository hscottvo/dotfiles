{ inputs, ... }:
{
  # One formatter for the repo: `nix fmt` (or `just fmt`). Sets the flake's
  # `formatter` output, which is what nix fmt and `nix flake check` use.
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";

      programs.nixfmt.enable = true;
      programs.stylua.enable = true;
      programs.taplo.enable = true;

      # lazy.nvim and nvim's builtin plugin manager own these.
      settings.global.excludes = [
        "nvim/lazy-lock.json"
        "nvim/nvim-pack-lock.json"
      ];
    };
  };
}
