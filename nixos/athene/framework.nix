{
  pkgs,
  lib,
  ...
}: let
  backlight_min_patch = {
    name = "backlight-min-quirk";
    patch = pkgs.fetchpatch2 {
      url = "https://lore.kernel.org/lkml/20240610-amdgpu-min-backlight-quirk-v1-1-8459895a5b2a@weissschuh.net/raw";
      hash = "sha256-tXxI+G9nNc+p4y8ITISe7EioCtETtePpeuCr+oWT/+4=";
    };
  };
in {
  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
    kernelPatches = [backlight_min_patch];
  };

  services.fwupd.enable = true;

  environment.systemPackages = [pkgs.fw-ectool];
}
