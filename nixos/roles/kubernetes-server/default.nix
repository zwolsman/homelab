{
  ...
}:
{
  imports = [ ../kubernetes ];
  services.k3s = {
    role = "server";
    extraFlags = [
      "--write-kubeconfig-mode \"0644\""
      "--disable servicelb"
      "--disable traefik"
      "--disable local-storage"
    ];
  };

}
