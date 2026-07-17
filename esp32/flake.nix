{
  description = "A generic flake-parts based flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-esp-dev = {
      # Waiting on:
      # https://github.com/mirrexagon/nixpkgs-esp-dev/pull/131
      # https://github.com/mirrexagon/nixpkgs-esp-dev/pull/132
      #url = "github:mirrexagon/nixpkgs-esp-dev";
      url = "github:Gigahawk/nixpkgs-esp-dev/personal";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
