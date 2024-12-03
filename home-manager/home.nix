{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./editor.nix
    ./shell.nix
    ./vscode.nix
    ./music.nix
  ];

  home = {
    username = "olivia";
    homeDirectory = "/home/olivia";
    file.".config/kanidm".text = ''
      uri = "https://auth.slug.gay/"
    '';
  };

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      fd
      jd-diff-patch
      nix-diff
      rename
      ripgrep
      shellcheck
      yubikey-manager

      ;
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
