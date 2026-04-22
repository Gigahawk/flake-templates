{ inputs, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShell {
          packages = [
            pkgs.hello
          ];
          env = {
            HELLO = "1";
          };

          shellHook = ''
            echo "Entering devshell"
          '';
        };
      };
    };
}
