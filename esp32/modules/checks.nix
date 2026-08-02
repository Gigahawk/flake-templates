{ inputs, self, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      checks = {
        clang-check =
          pkgs.runCommand "clang-check"
            {
              nativeBuildInputs = [
                inputs.nixpkgs-esp-dev.packages.${system}.esp-idf-full
              ];
            }
            ''
              mkdir -p $out/src
              cp -r ${toString self}/* $out/src
              cd $out/src
              chmod -R 777 *
              IDF_TOOLCHAIN=clang idf.py clang-check --exit-code
            '';
      };
    };
}
