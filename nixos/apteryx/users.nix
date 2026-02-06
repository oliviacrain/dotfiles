{pkgs, ...}: {
  users.users.slug = {
    isNormalUser = true;
    home = "/home/slug";
    packages = [pkgs.firefox];
    extraGroups = [ "wheel" ];
  };
}
