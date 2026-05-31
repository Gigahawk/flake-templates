{
  hacks,
  pythonPackage,
  pkgs,
  ...
}:
let
  pkg-name = import ./_package_name.nix { };
in
final: prev: {
  # Example overrides to fix build
  # psycopg2 = prev.psycopg2.overrideAttrs (old: {
  #   buildInputs = (old.buildInputs or [ ]) ++ [
  #     prev.setuptools
  #     pkgs.libpq.pg_config
  #   ];
  # });
  # casadi = hacks.nixpkgsPrebuilt {
  #   from = pkgs.python312Packages.casadi;
  #   prev = prev.casadi;
  # };

  ## TODO: Add tests to package?
  ## Based on https://pyproject-nix.github.io/uv2nix/patterns/testing.html
  ## Doesn't seem to work, ${pkg-name} package isn't found
  #${pkg-name} = prev.${pkg-name}.overrideAttrs (old: {
  #  passthru = old.passthru // {
  #    tests =
  #      let
  #        _virtualenv = final.mkVirtualEnv "${pkg-name}-pytest-env" workspace.deps.all // {
  #          ${pkg-name} = [ "dev" ];
  #        };
  #      in
  #      (old.tests or { })
  #      // {
  #        pytest = pkgs.stdenv.mkDerivation {
  #          name = "${final.${pkg-name}.name}-pytest";
  #          inherit (final.${pkg-name}) src;
  #          nativeBuildInputs = [
  #            virtualenv
  #            _virtualenv
  #          ];
  #          dontConfigure = true;
  #          buildPhase = ''
  #            runHook preBuild
  #            pytest
  #            runHook postBuild
  #          '';
  #        };
  #      };
  #  };
  #});

}
