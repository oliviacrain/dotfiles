{ pkgs, ... }:
let
  userName = "Olivia Crain";
  userEmail = "olivia@olivia.dev";
in
{
  home.packages = [ pkgs.difftastic ];
  programs.gh.enable = true;
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "${userName}";
        email = "${userEmail}";
      };
      aliases = {
        amend = [
          "squash"
          "--keep-emptied"
        ];
      };
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userName;
        email = userEmail;
        signingkey = "${./id_ed25519_sk.pub}";
      };
      aliases = {
        s = "status -s";
        oops = "commit --amend --no-edit";
      };
      merge.conflictStyle = "zdiff3";
      pull.ff = "only";
      push.autoSetupRemote = "true";
      rebase.autosquash = "true";
      rebase.updateRefs = "true";
      init.defaultBranch = "main";
      diff.external = "difft";
      gpg.format = "ssh";
      commit.gpgsign = "true";
      grep.patternType = "perl";
      branch.sort = "committerdate";
      column.ui = "auto";
    };
  };
}
