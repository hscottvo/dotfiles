{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      outOfStoreConfig = "/home/scott/dotfiles/noctalia";
      # settings =
      #   (builtins.fromJSON
      #     (builtins.readFile ./noctalia.json)).settings;
    };
  };
}
