{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;   # includes the default GNOME app suite

  networking.networkmanager.enable = true;       # backs GNOME's network settings

  # Audio via PipeWire (GNOME's default stack).
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Optional, later: trim default GNOME apps you never use.
  # environment.gnome.excludePackages = with pkgs; [ gnome-tour epiphany geary ];
}
