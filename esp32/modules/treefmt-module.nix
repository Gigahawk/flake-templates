{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.dos2unix.enable = true;

        programs.nixfmt.enable = true;

        # Doesn't really work for esp projects
        # Use idf.py clang-check instead
        # programs.clang-tidy.enable = true;
        programs.clang-format.enable = true;
        programs.cmake-format.enable = true;

        programs.actionlint.enable = true;
        programs.yamlfmt.enable = true;
      };
    };
}
