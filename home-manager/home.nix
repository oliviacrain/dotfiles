{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    ./git.nix
    ./editor.nix
    ./shell.nix
    ./vscode.nix
  ];

  home = {
    username = "olivia";
    homeDirectory = "/home/olivia";
  };

  home.packages = with pkgs; [
    diffoscope
    rename
    ripgrep
    rmapi
    shellcheck
    tree
    typst
    yubikey-manager
    nil
  ];

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
