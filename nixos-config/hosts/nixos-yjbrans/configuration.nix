{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/system.nix
    ../../modules/flatpak.nix
    ../../modules/home-manager.nix
  ];

  # The NixOS release this machine was FIRST installed with. It controls
  # defaults for stateful data (databases, file layouts). Never bump it on
  # upgrades; it is not your NixOS version.
  system.stateVersion = "26.05";
}
