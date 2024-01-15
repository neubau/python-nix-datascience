{
  system,
  inputs,
}: [
  (_: prev: let
    pkgs = prev.pkgs;
  in {
    inherit (inputs.llama-cpp.legacyPackages.${system}.llamaPackages) llama-cpp;
    # inherit (inputs.nixpkgs-stable.legacyPackages.${system}) poetry;
    # inherit (inputs.nixpkgs-stable.legacyPackages.${system}.python3Packages) xattr;
    python311 = prev.python311.override {
      packageOverrides = _: _: {
        mlx = pkgs.python311Packages.buildPythonPackage {
          pname = "mlx";
          version = "0.0.9";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/2f/36/4208524153211adddc3d7bc14532e6a306e726b32940e24acf589c5598c7/mlx-0.0.9-cp311-cp311-macosx_14_0_arm64.whl";
            sha256 = "837a4495b7e787b3dcc0c07ac970ec789421f5801aa90d68f177ecfaf7d31082";
          };
        };
      };
    };
  })
]
