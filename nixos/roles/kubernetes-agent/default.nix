{
  ...
}:

{
  imports = [ ../kubernetes ];
  services.k3s = {
    role = "agent";
    clusterInit = false;
  };

}
