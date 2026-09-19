{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";   # same rule as system.stateVersion: never bump

  # Per-user CLI tools (system-wide ones live in modules/system.nix).
  home.packages = with pkgs; [
    ripgrep
    fd
    tree
  ];

  programs.bash.enable = true;   # home-manager now owns ~/.bashrc

  programs.git = {
    enable = true;
    settings.user = {
      name = "Yannick Brans";         # ← CHANGE
      email = "yj.brans@outlook.com";  # ← CHANGE
    };
  };

  # GNOME settings, declared (these are dconf keys; `dconf watch /` shows
  # which key a Settings toggle changes).
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
  };
}
