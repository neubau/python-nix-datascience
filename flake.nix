{
  description = "Starter Configuration for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    llama-cpp.url = "github:ggerganov/llama.cpp";
  };
  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nixpkgs-stable,
    treefmt-nix,
    ...
  }: let
    pkgsForSystem = system: version:
      import version {
        inherit system;
        config.allowUnfree = true;
        overlays = import ./overlays {inherit system inputs;};
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        system,
        self',
        ...
      }: let
        stablePkgs = pkgsForSystem system nixpkgs-stable;
        pkgs = pkgsForSystem system nixpkgs;
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [];
          packages = [
            pkgs.python311
            pkgs.python311Packages.mlx
            pkgs.python311Packages.jupyterlab
            pkgs.python311Packages.pytest
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            prettier.enable = true;
          };
        };
      };
    };
}
