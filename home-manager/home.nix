{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
  ];

  home = {
    username = "olivia";
    homeDirectory = "/home/olivia";
  };

  programs.neovim.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.helix.enable = true;

  home.packages = with pkgs; [
    age
    diffoscope
    f3
    just
    nixpkgs-fmt
    ripgrep
    rmapi
    rnix-lsp
    shellcheck
    typst
    yubikey-manager
  ];

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
