{ lib, pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.firefox
    pkgs.kdePackages.neochat
    pkgs.kdePackages.tokodon
  ];

  fonts.packages = [ pkgs.berkeley-mono ];
}
