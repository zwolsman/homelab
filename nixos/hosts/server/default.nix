{ stateVersion, ... }:
{
  imports = [
    ../../users/server_admin.nix
    ../../users/deploy_user.nix
  ];

  nix.settings.trusted-users = [
    "server_admin"
    "deploy_user"
  ];

  services.openssh = {
    enable = true;

    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      22 # ssh
      53 # pihole, dns
      80 # http
      443 # https
      2379 # k3s, etcd client
      2380 # k3s, etcd peers
      5432 # db, PostgreSQL
      6443 # k3s, API server
      9100 # prometheus node exporter
      9500 # longhorn, manager
      10250 # k3s, kubelet metrics
    ];

    allowedUDPPorts = [
      53 # pihole, dns
      8472 # k3s, flannel
      31497 # factorio server
    ];
  };

  system.stateVersion = stateVersion;
}
