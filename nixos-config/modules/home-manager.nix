{ username, ... }:
{
  home-manager = {
    useGlobalPkgs = true;      # reuse the system's nixpkgs (and allowUnfree)
    useUserPackages = true;    # install user packages into /etc/profiles, not ~/.nix-profile
    backupFileExtension = "hm-backup";  # rename, don't fail, if a dotfile already exists
    extraSpecialArgs = { inherit username; };
    users.${username} = import ../home/home.nix;
  };
}
