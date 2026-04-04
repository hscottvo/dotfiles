{ self, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        xwayland-satellite
        self.packages.${pkgs.system}.myNoctalia
      ];
    };
}
