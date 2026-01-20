{
  description = "Playground for wpgu noodling";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [(import rust-overlay)];
        };
        rust = pkgs.rust-bin.stable.latest.default.override {extensions = ["rust-src"];};
      in {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.pkg-config
            pkgs.rust-analyzer-unwrapped
            rust
          ];
          shellHook = ''
            export RUST_SRC_PATH="${rust}/lib/rustlib/src/rust/library"
          '';
        };
      }
    );
  };
}
