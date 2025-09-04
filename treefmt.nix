{...}: {
  projectRootFile = "./flake.nix";
  programs = {
    alejandra.enable = true;
    just.enable = true;
    terraform.enable = true;
  };
}
