{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;

  # python
  programs.ruff-check.enable = true;
  programs.ruff-format.enable = true;

  # toml
  programs.taplo.enable = true;
  programs.toml-sort.enable = true;

  # md
  programs.mdformat.enable = true;

  #programs.actionlint.enable = true;
  #programs.yamlfmt.enable = true;
}