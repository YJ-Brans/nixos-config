# Single source of truth for the values that differ per person/machine.
# Read by flake.nix, host/disko.nix and install.sh.
{
  hostname = "nixos-desktop-yjbrans";
  username = "yjbrans";              # lowercase login name
  fullName = "Yannick Brans";
  email    = "yj.brans@outlook.com";  # used for git commits
  timezone = "Europe/Amsterdam";

  # The NixOS disk ONLY. Set this on the live USB (Step 3). Must be a
  # whole-disk /dev/disk/by-id/... path, never a -partN entry.
  disk = "/dev/disk/by-id/REPLACE-ME";
}
