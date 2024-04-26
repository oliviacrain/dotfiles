{ ... }:
let
  trivial = {
    path = ./trivial;
    description = "Basic flake with tooling I use";
  };
  rust = {
    path = ./rust;
    description = "Oxalica rust-overlay flake";
  };
in
{
  default = trivial;
  inherit trivial rust;
}
