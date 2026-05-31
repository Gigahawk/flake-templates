{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      libDir = "${config.packages.venvAll}/lib";
      pyDir = builtins.head (builtins.attrNames (builtins.readDir libDir));
      siteDir = "${libDir}/${pyDir}/site-packages";
    in
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.dos2unix.enable = true;

        # python
        programs.ruff-check.enable = true;
        programs.ruff-format.enable = true;
        programs.mypy = {
          enable = true;
          directories = {
            "" = {
              options = [ "--check-untyped-defs" ];
              extraPythonPaths = [ siteDir ];
            };
          };
        };

        # toml
        programs.taplo.enable = true;
        programs.toml-sort.enable = true;

        # md
        programs.mdformat.enable = true;

        # yml
        programs.actionlint.enable = true;
        programs.yamlfmt.enable = true;

      };
    };
}
