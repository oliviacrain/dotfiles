{
  inputs,
  outputs,
  ...
}:
let
  mkSystem = name: system: {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs outputs;
      };
      modules = [ ./${name}/configuration.nix ];
    };
  };
in
mkSystem "apteryx" "x86_64-linux"
// mkSystem "athene" "x86_64-linux"
// mkSystem "cardinalis" "x86_64-linux"
// mkSystem "strigidae" "x86_64-linux"
# // mkSystem "corvus" "aarch64-linux" 🫡
