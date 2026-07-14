{
  description = "A collection of flake templates";

  outputs =
    { self }:
    {
      templates = {
        python = {
          path = ./python;
          description = "Python template, using uv2nix";
          welcomeText = ''
            # Getting started
            TODO: FILL THIS IN
          '';
        };
        flake-parts = {
          path = ./flake-parts;
          description = "Flake-parts template";
          welcomeText = ''
            # Getting started
            TODO: FILL THIS IN
          '';
        };
        esp32 = {
          path = ./esp32;
          description = "ESP32 project template";
          welcomeText = ''
            # Devshell

            See available targets with `idf.py --list-targets`
            Set a target with `idf.py set-target <target>`

            Build, flash, monitor a connected target with `idf.py build flash monitor`
          '';
        };
      };
    };
}
