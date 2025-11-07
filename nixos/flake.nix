{
  description = "Homelab NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Set the primary/default user. Can be overwritten on a system level
      user = "marv";

      commonInherits = {
        inherit (nixpkgs) lib;
        inherit
          inputs
          outputs
          nixpkgs
          ;
      };

      systems = {
        homelab-0 = {
          systemType = "server";
          roles = [
            /kubernetes
          ];
        };

        homelab-1 = {
          systemType = "server";
          roles = [
            /kubernetes
          ];
        };

        homelab-2 = {
          systemType = "server";
          roles = [
            /kubernetes
          ];
        };

        homelab-3 = {
          systemType = "server";
          roles = [
            /kubernetes
          ];
        };

        homelab-4 = {
          systemType = "server";
          roles = [
            /kubernetes
          ];
        };
      };

      mkSystem =
        host: system:
        import ./hosts.nix (
          commonInherits
          // {
            hostName = "${host}";
            user = system.user or user;
            serverType = system.serverType or null;
          }
          // system
        );
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems;
    };
}
