# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  meta,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.

  ];

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Configure sops secrets
  sops.defaultSopsFile = ./secrets.yaml;

  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Secrets used in configuration
  sops.secrets.tailscale-auth-key = { };
  sops.secrets.k3s-token = { };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  # Fixes for longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  virtualisation.docker.logDriver = "json-file";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.k3s = {
    enable = true;
    role = "server";
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
        if meta.hostname == "homelab-0" then
          [ ]
        else
          [
            "--server https://192.168.178.151:6443"
          ]
      )
    );
    clusterInit = (meta.hostname == "homelab-0");
  };

  # services.openiscsi = {
  #   enable = true;
  #   name = "iqn.2016-04.com.open-iscsi:${meta.hostname}";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account
  users.users.homelab = {
    isNormalUser = true;
    description = "homelab";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      tree,
      nano
    ];
    hashedPassword = "$y$j9T$s0hofXXtqSw/2xvrPMmIK/$a1C0/Ao4WM6LJtHEHlmCERMJ03oj9Y9kQJRYTfg4xP0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0dyepv7Mynvj4EqLWfM0DtAz20ZI8+AfU/qhHiAsXP thomvandevin@thomvandevin-macbook.local"
    ];
  };
  
  # Define a user account
  users.users.github = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [

    ];
    # Created using mkpasswd
    hashedPassword = "$y$j9T$s0hofXXtqSw/2xvrPMmIK/$a1C0/Ao4WM6LJtHEHlmCERMJ03oj9Y9kQJRYTfg4xP0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0dyepv7Mynvj4EqLWfM0DtAz20ZI8+AfU/qhHiAsXP thomvandevin@thomvandevin-macbook.local"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    k3s
    cifs-utils
    nfs-utils
    git
    jq
    tailscale
    bat
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = false;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      "10.0.0.0/8" # k8s
      "192.168.0.0/16" # home network
      "100.64.0.0/10" # tailscale
    ];
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

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $(cat ${config.sops.secrets.tailscale-auth-key.path})
    '';
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
