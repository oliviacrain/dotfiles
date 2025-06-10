{
  lib,
  pkgs,
  ...
}: let
  userSettings = {
    "extensions.autoCheckUpdates" = false;
    "extensions.ignoreRecommendations" = true;
    "update.mode" = "none";
    "update.showReleaseNotes" = false;

    "terminal.integrated.defaultProfile.linux" = "bash";
    "terminal.integrated.fontFamily" = "'Berkeley Mono Variable'";
    "editor.fontFamily" = "'Berkeley Mono Variable'";

    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;

    "workbench.colorTheme" = "Witch Hazel Hypercolor";
    "window.titleBarStyle" = "custom";

    "editor.lineNumbers" = "relative";

    "nix.enableLanguageServer" = true;
    "nix.formatterPath" = "${lib.getExe pkgs.nixfmt-rfc-style}";
    "nix.serverPath" = "${lib.getExe pkgs.nil}";
  };
in {
  programs.vscode = {
    enable = true;
    profiles.default = {
      inherit userSettings;
      extensions = with pkgs.vscode-marketplace; [
        theaflowers.witch-hazel
        jnoortheen.nix-ide
        mkhl.direnv
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        pkgs.vscode-extensions.ms-vscode.cpptools
      ];
    };
  };
}
