{ pkgs, ...}:
{
  home.packages = [pkgs.difftastic];
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
      user.signingkey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev";
    };
  };
}
