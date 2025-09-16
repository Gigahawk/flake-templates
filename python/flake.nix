{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pyproject-nix,
    uv2nix,
    pyproject-build-systems,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs {inherit system;};
      python = pkgs.python312;

      workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ./.;};
      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };
      hacks = pkgs.callPackage pyproject-nix.build.hacks {};
      pyprojectOverrides = final: prev: {
        # Example override to fix build
        psycopg2 = prev.psycopg2.overrideAttrs (old: {
          buildInputs =
            (
              old.buildInputs or []
            )
            ++ [
              prev.setuptools
              pkgs.libpq.pg_config
            ];
        });
      };

      pythonSet =
        (
          pkgs.callPackage pyproject-nix.build.packages {
            inherit python;
          }
        ).overrideScope (
          lib.composeManyExtensions [
            pyproject-build-systems.overlays.default
            overlay
            pyprojectOverrides
          ]
        );

      inherit (pkgs.callPackages pyproject-nix.build.util {}) mkApplication;
    in {
      packages = {
        hello = mkApplication {
          venv =
            pythonSet.mkVirtualEnv "application-env"
            workspace.deps.default;
          package = pythonSet.hello;
        };
        default = self.packages.${system}.hello;
      };
      devShells = {
        impure = pkgs.mkShell {
          packages = [
            python
            pkgs.uv
          ];
          env =
            {
              UV_PYTHON_DOWNLOADS = "never";
              UV_PYTHON = python.interpreter;
            }
            // lib.optionalAttrs pkgs.stdenv.isLinux {
              LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            };
          shellHook = ''
            unset PYTHONPATH
          '';
        };

        default = self.devShells.${system}.impure;
      };
    });
}
