{ config, lib, ... }:

{

  imports = [
    ./modules/core.nix
    ./modules/nix-config.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/users.nix

    ./gui/fonts.nix
    ./gui/gui.nix
    ./gui/theme.nix
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "23.11";

}
