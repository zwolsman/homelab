{
  inputs,
  pkgs,
  user,
  ...
}:

{
  imports = [
    ./users/${user}.nix
    ./modules/zsh.nix
    ./modules/tailscale.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ==============================
  # Shared Sops configuration
  # ==============================
  sops = {
    defaultSopsFile = ./secrets.yaml;

    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
  };
  # ==============================

  environment.systemPackages = with pkgs; [
    btop
    dig
    tree
    traceroute
  ];

  # Keep SSH agent in sudo
  security.sudo = {
    extraConfig = ''
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults timestamp_timeout=30
    '';
  };
}
