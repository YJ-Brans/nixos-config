{ pkgs, lib, ... }:
let
  theme = "vimix";   # ← CHANGE: "catppuccin" | "sleek" | "vimix"
in
{
  config = lib.mkMerge [
    {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;   # register "NixOS" in the firmware boot list
          efiSysMountPoint = "/boot";     # the NixOS disk's own ESP
        };
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";            # UEFI: install into the ESP, not a disk's MBR
          useOSProber = true;          # detect Windows on the other disk, add a menu entry
          configurationLimit = 10;     # newest 10 generations in the menu
        };
      };

      # The vimix module switches itself on when imported; keep it off unless chosen.
      boot.loader.grub2-theme.enable = theme == "vimix";
    }

    (lib.mkIf (theme == "catppuccin") {
      # flavor: "latte" | "frappe" | "macchiato" | "mocha"
      boot.loader.grub.theme = pkgs.catppuccin-grub.override { flavor = "mocha"; };
      # boot.loader.grub.gfxmodeEfi = "1920x1080";  # uncomment if text looks tiny on a 4K screen
    })

    (lib.mkIf (theme == "sleek") {
      # withStyle: "light" | "dark" | "orange" | "bigSur"
      boot.loader.grub.theme = pkgs.sleek-grub-theme.override {
        withStyle = "dark";
        withBanner = "Choose your OS";
      };
    })

    (lib.mkIf (theme == "vimix") {
      boot.loader.grub2-theme = {
        theme = "tela";     # or "vimix" | "stylish" | "whitesur"
        icon = "white";      # "color" | "white" | "whitesur"
        screen = "2k";    # "1080p" | "2k" | "4k" | "ultrawide" | "ultrawide2k"
      };
    })
  ];
}
