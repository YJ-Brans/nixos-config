{ pkgs, hostname, username, ... }:
{
  networking.hostName = hostname;

  time.timeZone = "Europe/Amsterdam";   # ← CHANGE if needed
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];   # wheel = may use sudo
  };

  nixpkgs.config.allowUnfree = true;   # NVIDIA driver, and nothing else by default

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;        # hard-link identical files in /nix/store
  };
  nix.channel.enable = false;          # flakes only: no legacy channels at all

  # Weekly cleanup of generations older than 14 days, then the unused store paths.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    persistent = true;                 # catch up if the PC was off at the scheduled time
  };

  # Compressed swap in RAM instead of a swap partition.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Trusted CLI/system tools from nixpkgs (no sandboxing needed).
  environment.systemPackages = with pkgs; [
    git
    htop
    vim
    wget
    curl
    pciutils   # lspci
    usbutils   # lsusb
  ];

  # No SSH server: services.openssh stays at its default (disabled).
}
