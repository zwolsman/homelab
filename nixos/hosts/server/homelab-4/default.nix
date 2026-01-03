{ config, pkgs, ... }:
{
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
  };
  boot.kernelModules = [ "nvidia" ];
  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.containerd = {
    enable = true;
    settings = {
      version = 2;
      plugins."io.containerd.grpc.v1.cri" = {
        containerd = {
          runtimes = {
            nvidia = {
              runtime_type = "io.containerd.runc.v2";
              options = {
                BinaryName = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
              };
            };
          };
          default_runtime_name = "nvidia";
        };
      };
    };
  };
  services.udev.extraRules = ''
    KERNEL=="renderD*", GROUP="video", MODE="0666"
  '';
}
