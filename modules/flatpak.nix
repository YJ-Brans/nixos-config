{ ... }:
{
  services.flatpak = {
    enable = true;

    packages = [
      "org.mozilla.firefox"
      "com.discordapp.Discord"
      "com.github.tchx84.Flatseal"   # GUI to inspect/adjust each app's sandbox permissions
    ];

    # Keep the list authoritative: Flatpaks you didn't declare here (e.g. installed
    # through GNOME Software) are removed on the next rebuild.
    uninstallUnmanaged = true;

    # Don't update apps on every rebuild; update when you choose (`flatpak update`).
    update.onActivation = false;
  };
}
