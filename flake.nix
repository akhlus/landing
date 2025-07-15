{
  description = "Dev shell for quarto development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          numpy
          matplotlib
        ]);
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            quarto
            pandoc
            pythonEnv
          ];

          shellHook = ''
            export PATH=${pythonEnv}/bin:$PATH
            export PYTHONPATH=${pythonEnv}/${pkgs.python3.sitePackages}:$PYTHONPATH
          '';
        };
      }
    );
}
