{
  description = "A collectoin of flake templates";

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
    };
  };
}
