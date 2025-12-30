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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pyproject-nix,
    uv2nix,
    pyproject-build-systems,
    treefmt-nix,
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
      editableOverlay = workspace.mkEditablePyprojectOverlay {
        root = "$REPO_ROOT";
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
            pyproject-build-systems.overlays.wheel
            overlay
            pyprojectOverrides
          ]
        );

      editablePythonSet = pythonSet.overrideScope editableOverlay;
      virtualenv = editablePythonSet.mkVirtualEnv "hello-dev-env" workspace.deps.all;

      inherit (pkgs.callPackages pyproject-nix.build.util {}) mkApplication;

      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in {
      packages = {
        hello = mkApplication {
          venv =
            pythonSet.mkVirtualEnv "hello-app-env"
            workspace.deps.default;
          package = pythonSet.hello;
        };
        default = self.packages.${system}.hello;
      };
      formatter = treefmtEval.config.build.wrapper;
      checks = {
        formatting = treefmtEval.config.build.check self;
      };
      devShells = {
        default = pkgs.mkShell {
          packages = [
            virtualenv
            pkgs.uv
            pkgs.sphinx
          ];
          env =
            {
              UV_NO_SYNC = "1";
              UV_PYTHON = editablePythonSet.python.interpreter;
              UV_PYTHON_DOWNLOADS = "never";
            }
            // lib.optionalAttrs pkgs.stdenv.isLinux {
              LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            };
          shellHook = ''
            unset PYTHONPATH
            export REPO_ROOT=$(git rev-parse --show-toplevel)
            . ${virtualenv}/bin/activate
          '';
        };
      };
    });
}
