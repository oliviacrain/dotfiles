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

  home = {
    username = "olivia";
    homeDirectory = "/home/olivia";
  };

  programs.neovim.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.gh.enable = true;

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
  programs.git = {
    enable = true;
    userName = "Olivia Crain";
    userEmail = "olivia@olivia.dev";
    aliases = {
      s = "status";
    };
    extraConfig = {
      gpg.format = "ssh";
      commit.gpgsign = "true";
      user.signingkey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev";
    };
  };

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
