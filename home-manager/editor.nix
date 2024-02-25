{ lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      nil
      gopls
      gotools
      rust-analyzer
      nodePackages.bash-language-server
      nixfmt-rfc-style
    ];

    languages = {
      language = [
        {
          name = "nix";
          formatter.command = "${lib.getExe pkgs.nixfmt-rfc-style}";
        }
      ];
    };

    settings = {
      theme = "witchhazel-hyper";
      editor = {
        line-number = "relative";
      };
    };

    themes = {
      witchhazel = lib.importTOML "${pkgs.witchhazel}/helix/witchhazel.toml";
      witchhazel-hyper = lib.importTOML "${pkgs.witchhazel}/helix/witchhazel_hyper.toml";
    };
  };
}
