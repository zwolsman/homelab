# Admin with passwordless sudo
{
  users.users."server_admin" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4Xrt0Mk/Ca3TpIBcGgtEVVTDTkUb5GT5PeX7qwRYKt gitlab"
    ];
  };

  security.sudo = {
    extraRules = [
      {
        users = ["server_admin"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}