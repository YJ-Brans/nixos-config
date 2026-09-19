#!/usr/bin/env bash
# install.sh: run ONCE from the NixOS live USB, as root, after partitioning
# and mounting the target disk at /mnt (its ESP at /mnt/boot).
# Usage: ./install.sh [hostname] [username]
set -euo pipefail

HOST="${1:-nixbox}"
USERNAME="${2:-alex}"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NIX_CONFIG="experimental-features = nix-command flakes"

die() { echo "ERROR: $*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ]     || die "run as root (sudo -i first)"
[ -d /sys/firmware/efi ] || die "not booted in UEFI mode"
mountpoint -q /mnt       || die "/mnt is not mounted"
mountpoint -q /mnt/boot  || die "/mnt/boot is not mounted"
[ -f "$REPO/hosts/$HOST/configuration.nix" ] || die "missing hosts/$HOST/configuration.nix"
grep -q "hostname = \"$HOST\"" "$REPO/flake.nix"     || die "flake.nix hostname is not '$HOST'"
grep -q "username = \"$USERNAME\"" "$REPO/flake.nix" || die "flake.nix username is not '$USERNAME'"

IS_GIT=0
if [ -d "$REPO/.git" ]; then
  command -v git >/dev/null || die "git not found: run inside 'nix-shell -p git'"
  IS_GIT=1
fi

echo "==> Target filesystems:"
findmnt -R /mnt
read -rp "Install NixOS onto these? [y/N] " ok
[ "$ok" = "y" ] || die "aborted"

echo "==> Generating hosts/$HOST/hardware-configuration.nix"
nixos-generate-config --root /mnt --show-hardware-config \
  > "$REPO/hosts/$HOST/hardware-configuration.nix"
[ "$IS_GIT" = 1 ] && git -C "$REPO" add -A   # flakes only see tracked files

echo "==> Installing (downloads a lot; roughly 10-40 minutes)"
nixos-install --root /mnt --flake "$REPO#$HOST" --no-root-passwd
[ "$IS_GIT" = 1 ] && git -C "$REPO" add -A   # stage the new flake.lock

echo "==> Copying the repo to /home/$USERNAME/nixos-config"
mkdir -p "/mnt/home/$USERNAME"
cp -aT "$REPO" "/mnt/home/$USERNAME/nixos-config"   # -T: safe to re-run

echo "==> Setting ownership and the password for $USERNAME"
nixos-enter --root /mnt -c "chown -R $USERNAME:users /home/$USERNAME && passwd $USERNAME"

echo "==> Done. Now: umount -R /mnt && reboot"
