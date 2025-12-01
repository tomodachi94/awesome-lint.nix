# `awesome-lint.nix`: [Awesome Lint](https://github.com/sindresorhus/awesome-lint) packaged for Nix

Because [Awesome Lint was dropped from Nixpkgs](https://github.com/NixOS/nixpkgs/pull/462749) for being impractical to maintain in-tree, let's make a flake so people can continue to use it in CI pipelines.

## Using

Use it like this:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    awesome-lint = {
      url = "github:tomodachi94/awesome-lint.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      devShells = eachSystem (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          pkgs.mkShellNoCC {
            packages = [
              awesome-lint.packages.${system}.awesome-lint
              # Other tools here
              # We suggest nixfmt if you're using Nix in your repository
              pkgs.nixfmt
            ];
          };
      });
    };
}
```

## Contributing

Use `nix develop` to get developer tooling.

Use `just build` (or `nix build`) to build the package.

Use `just format` to run a few code formatters on new code.
