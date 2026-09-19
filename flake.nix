{
  description = "NixOS + GNOME + NVIDIA, dual-boot with Windows 11";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Only used if you choose the "vimix" GRUB theme in modules/boot.nix.
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, grub2-themes, ... }@inputs:
    let
      hostname = "nixos-yjbrans";   	# ← CHANGE if you want a different hostname
      username = "yjbrans";     	# ← CHANGE to your login name
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        # Makes `hostname`, `username` and `inputs` available to every module.
        specialArgs = { inherit inputs hostname username; };
        modules = [
          (./hosts + "/${hostname}/configuration.nix")
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
          grub2-themes.nixosModules.default
        ];
      };
    };
}
