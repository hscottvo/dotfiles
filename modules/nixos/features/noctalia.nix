{
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = pkgs.symlinkJoin {
      name = "noctalia-configured";
      paths = [ pkgs.noctalia ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/noctalia \
          --set NOCTALIA_CONFIG_HOME /home/scott/dotfiles \
          --set TERMINAL ghostty
      '';
    };
  };
}
