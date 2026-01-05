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
  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
  };
  boot.kernelModules = [ "nvidia" ];
  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.mount-nvidia-executables = true;
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    nvidia-container-toolkit.tools
    runc
  ];
  services.k3s.containerdConfigTemplate = ''
    # Base K3s config
      {{ template "base" . }}

      # Add a custom runtime
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."nvidia"]
        runtime_type = "io.containerd.runc.v2"
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."nvidia".options]
        BinaryName = "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime"
  '';
  virtualisation.containerd = {
    enable = false;
  };
  services.udev.extraRules = ''
    KERNEL=="renderD*", GROUP="video", MODE="0666"
  '';
}
