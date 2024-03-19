{ lib, pkgs, ... }:
let
  inherit (builtins) attrValues;
in
{

  environment.systemPackages = attrValues {
    inherit (pkgs)
      firefox
      clamav
      calibre
      ;
  } ++ attrValues {
    inherit (pkgs.kdePackages)
      neochat
      tokodon
      ;
  };

  fonts.packages = [ pkgs.berkeley-mono ];
}
