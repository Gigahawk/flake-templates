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
      packages =
        let
          project-name = pkgs.lib.trim (builtins.readFile ../project_name.txt);

          # https://discourse.nixos.org/t/how-to-create-a-timestamp-in-a-nix-expression/30329/2
          last-modified-str = builtins.readFile "${pkgs.runCommand "timestamp" {
            when = self.lastModified;
          } "echo -n `date -d @$when +%Y-%m-%d_%H-%M-%S` > $out"}";
          # https://discourse.nixos.org/t/flakes-accessing-selfs-revision/11237/8
          rev-str = "${
            toString (self.ref or self.shortRev or self.dirtyShortRev or "unknown")
          }_${last-modified-str}";
        in
        {
          "${project-name}-bin" = pkgs.stdenv.mkDerivation {
            pname = "${project-name}.bin";
            # TODO: do something about this?
            version = rev-str;

            src = self;

            nativeBuildInputs = [
              inputs.nixpkgs-esp-dev.packages.${system}.esp-idf-full
            ];

            dontConfigure = true;

            buildPhase = ''
              idf.py build
            '';

            installPhase = ''
              cp build/${project-name}.bin $out
            '';
          };

          default = self'.packages."${project-name}-bin";
        };
    };
}
