{...}: {
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
      fetchart = {
        auto = true;
      };
      plugins = ["convert" "info" "spotify" "mbsubmit" "fetchart"];
    };
  };
}
