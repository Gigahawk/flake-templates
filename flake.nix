{
  description = "A collection of flake templates";

  outputs = {self}: {
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
    };
  };
}
