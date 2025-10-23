{
  pkgs,
  ...
}:
#
# Minimal config for golden images. Must be entirely independent
# ie. not require any secrets, flake inputs, etc.
#
{
  imports = [
    ./base.nix
    ./users/server_admin.nix
  ];

  nix.settings.trusted-users = [
    "server_admin"
  ];

  environment.systemPackages = with pkgs; [
    btop
  ];

  services.openssh.enable = true;

  services.openssh.settings.PermitRootLogin = "yes";
}
