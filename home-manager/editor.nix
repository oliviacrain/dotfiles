{
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables.EDITOR = "hx";

  programs.helix = {
    enable = true;

    extraPackages = builtins.attrValues {
      inherit
        (pkgs)
        nil
        gopls
        gotools
        rust-analyzer
        nixfmt-rfc-style
        ;
      inherit (pkgs.nodePackages) bash-language-server;
    };

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

  programs.zed-editor = {
    enable = true;
    extraPackages = builtins.attrValues {
      inherit (pkgs)
        nil
        ;
    };
    extensions = [
      "git-firefly"
      "html"
      "jinja2"
      "just"
      "nix"
      "night-owlz"
      "sql"
      "just"
      "terraform"
      "toml"
    ];
  };
}
