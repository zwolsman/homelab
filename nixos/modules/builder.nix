{ ... }:
{
  nix = {
    distributedBuilds = true;
    settings = {
      builders-use-substitutes = true;
    };

    buildMachines = [
      {
        hostName = "builder";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        # maxJobs = 2;
        # speedFactor = 2;
        sshUser = "nix-builder";
        sshKey = "/root/.ssh/id_ed25519_nix-builder";
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [ ];
      }
    ];
  };
}
