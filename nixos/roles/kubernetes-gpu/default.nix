{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    nvidia-container-toolkit.tools
    runc
  ];

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

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.mount-nvidia-executables = true;

  boot.kernelModules = [ "nvidia" ];

  services.udev.extraRules = ''
    KERNEL=="renderD*", GROUP="video", MODE="0666"
  '';

  services.k3s.containerdConfigTemplate = ''
    # Base K3s config
    {{ template "base" . }}

    # Add a custom runtime
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."nvidia"]
      runtime_type = "io.containerd.runc.v2"
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."nvidia".options]
      BinaryName = "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime"
  '';
}
