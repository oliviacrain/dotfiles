{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  imports = [
    ./git.nix
    ./editor.nix
    ./shell.nix
  ];

  home = {
    username = "olivia";
    homeDirectory = "/home/olivia";
  };

  home.packages = with pkgs; [
    age
    diffoscope
    difftastic
    f3
    just
    rename
    ripgrep
    rmapi
    shellcheck
    tree
    typst
    yubikey-manager
  ];

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
