{pkgs, ...}: let
  userName = "Olivia Crain";
  userEmail = "olivia@olivia.dev";
in {
  home.packages = [pkgs.difftastic];
  programs.gh.enable = true;
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "${userName}";
        email = "${userEmail}";
      };
      aliases = {
        amend = [ "squash" "--keep-emptied" ];
      };
    };
  };
  programs.git = {
    enable = true;
    inherit userName userEmail;
    aliases = {
      s = "status -s";
      oops = "commit --amend --no-edit";
    };
    extraConfig = {
      merge.conflictStyle = "zdiff3";
      pull.ff = "only";
      push.autoSetupRemote = "true";
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
