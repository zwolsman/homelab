{
  pkgs,
  ...
}:
{

  users.users.marv = {
    description = "Marv";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      jq
      bat
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4Xrt0Mk/Ca3TpIBcGgtEVVTDTkUb5GT5PeX7qwRYKt gitlab"
    ];
    hashedPassword = "$6$b6e5fDij9m0Sfcbb$sj3aWtVhB.tpWBesVysKOuHjlQ/9FCpAUR0ktF2n4xHuGFKvOUoOMgP2icn5gqjHIui/.SWFW44eNG3KkYTIp/";
  };
}
