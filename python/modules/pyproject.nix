{ inputs, ... }:
{
  imports = [ inputs.flake-parts-python.flakeModules.default ];
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      wrapPython = {
        workspaceRoot = ../.;
        pythonPackage = pkgs.python314;
        pyprojectOverridesPath = ./_pyproject-overrides.nix;
      };
    };

}
