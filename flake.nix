{
  description = "A basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        awesome-lint = nixpkgs.legacyPackages.${system}.callPackage ./package.nix { };
        default = self.packages.${system}.awesome-lint;
      });
      devShells = eachSystem (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          pkgs.mkShellNoCC {
            packages = with pkgs; [
              just
              yamlfmt
              nixfmt-rfc-style
            ];
          };
      });
    };
}
