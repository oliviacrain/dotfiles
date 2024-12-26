{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = ["${pkgs.witchhazel}/alacritty/witchhazel_hyper.toml"];
      font.normal.family = "Berkeley Mono Variable";
    };
  };
  programs.atuin = {
    enable = true;
    settings.sync_address = "https://atuin.slug.gay";
  };
  programs.bat.enable = true;
  programs.bash.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };
  programs.fzf.enable = true;
  programs.jq.enable = true;
  programs.eza.enable = true;
  programs.nushell.enable = true;
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.zoxide.enable = true;
}
