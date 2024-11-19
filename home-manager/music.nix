{lib, ...}:
{
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Music/beets/";
      library = "~/.local/share/beets/library.db";
      convert = {
        auto = "yes";
        embed = "no";
        format = "opus";
      };
      plugins = ["convert" "info" "spotify" "mbsubmit"];
    };
  };
}
