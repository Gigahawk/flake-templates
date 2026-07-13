{ inputs, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      devShells = {
        inherit (inputs.nixpkgs-esp-dev.devShells.${system}) default;
      };
    };
}
