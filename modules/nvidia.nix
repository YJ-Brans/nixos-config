{ config, ... }:
{
  hardware.graphics.enable = true;               # was hardware.opengl before 24.11
  services.xserver.videoDrivers = [ "nvidia" ];  # this is what turns the NVIDIA module on,
                                                 # even on a Wayland-only desktop
  hardware.nvidia = {
    open = true;   # ← CHANGE to false for GTX 10xx and older (see tutorial Step 3.5)
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_580;  # GTX 9xx/10xx

    modesetting.enable = true;   # required for Wayland
    nvidiaSettings = true;       # installs the nvidia-settings GUI
    powerManagement.enable = false;  # set true if the screen is garbled after suspend
  };
}
