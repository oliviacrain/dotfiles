{ lib, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
}
