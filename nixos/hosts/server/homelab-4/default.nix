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
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit.tools
  ];
  virtualisation.containerd = {
    enable = false;
  };
  services.udev.extraRules = ''
    KERNEL=="renderD*", GROUP="video", MODE="0666"
  '';
}
