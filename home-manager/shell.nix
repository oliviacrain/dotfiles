{ ... }:
{
  programs.bat.enable = true;
  programs.bash.enable = true;
  programs.alacritty.enable = true;
  programs.atuin.enable = true;
  programs.zellij.enable = true;
  programs.fzf.enable = true;
  programs.nushell.enable = true; 
  programs.jq.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
