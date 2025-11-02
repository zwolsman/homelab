{
  config,
  pkgs,
  hostName,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    k3s
    cifs-utils
    nfs-utils
  ];

  sops.secrets.k3s-token = { };

  services.k3s = {
    enable = true;
    role = "server"; # TODO: extract role
    tokenFile = config.sops.secrets.k3s-token.path;
    extraFlags = toString (
      [
        "--write-kubeconfig-mode \"0644\""
        "--cluster-init"
        "--disable servicelb"
        "--disable traefik"
        "--disable local-storage"
      ]
      ++ (
        if hostName == "homelab-0" then
          [ ]
        else
          [
            "--server https://192.168.1.150:6443" # TODO: extract the boot server
          ]
      )
    );
    clusterInit = (hostName == "homelab-0");
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${hostName}";
  };

  # Fixes for longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
}
