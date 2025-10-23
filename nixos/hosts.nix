{
  inputs,
  nixpkgs,
  hostName,
  user,
  systemType ? "server",
  roles ? [ ],
  extraImports ? [ ],
  ...
}:
# Inspired by https://github.com/Baitinq/nixos-config/blob/31f76adafbf897df10fe574b9a675f94e4f56a93/hosts/default.nix
let
  commonNixOSModules = hostName: systemType: [
    # Set common config options
    {
      networking.hostName = hostName;
    }
    # Include our host specific config
    ./hosts/${systemType}/${hostName}

    # Absolute minimum config required
    ./base.nix

    # Include our shared configuration
    ./common.nix

    # Include our shared system type configuration
    ./hosts/${systemType}

    # Add in sops
    inputs.sops-nix.nixosModules.sops

    # Add in disko
    inputs.disko.nixosModules.disko
  ];

  mkNixRoles = roles: (map (n: ./roles/${n}) roles);

  mkHost =
    hostName: user: systemType: roles: extraImports:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules =
        # Shared modules
        commonNixOSModules hostName systemType
        # Add all our specified roles
        ++ mkNixRoles roles;

      #mkNixRoles hostName roles;

      specialArgs = {
        inherit inputs;
        inherit user;
        inherit hostName;
      };
    };
in
mkHost hostName user systemType roles extraImports
