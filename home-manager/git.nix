{ pkgs, ... }:
{
  home.packages = [ pkgs.difftastic ];
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Olivia Crain";
    userEmail = "olivia@olivia.dev";
    aliases = {
      s = "status -s";
    };
    extraConfig = {
      merge.conflictStyle = "zdiff3";
      pull.ff = "only";
      rebase.autosquash = "true";
      rebase.updateRefs = "true";
      init.defaultBranch = "main";
      diff.external = "difft";
      gpg.format = "ssh";
      commit.gpgsign = "true";
      user.signingkey = "${./id_ed25519_sk.pub}";
    };
  };
}
