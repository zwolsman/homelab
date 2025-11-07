{
  users.users."nix-builder" = {
    isNormalUser = true;
    createHome = false;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8kVbVBee4JzUwOel0YD0/LVbpfhQIZlGdo/VgurCk1 nix-builder"
    ];
    group = "nix-builder";
  };

  users.groups."nix-builder" =
    {
    };

  nix.settings.trusted-users = [ "nix-builder" ];
}
