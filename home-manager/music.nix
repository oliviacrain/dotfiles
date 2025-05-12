{...}: {
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Music/beets/";
      library = "~/.local/share/beets/library.db";
      convert = {
        auto = "yes";
        embed = "no";
        format = "flac";
        copy_album_art = "yes";
      };
      embedart = {
        auto = "no";
      };
      fetchart = {
        auto = true;
      };
      plugins = ["convert" "embedart" "info" "spotify" "mbsubmit" "fetchart"];
    };
  };
}
