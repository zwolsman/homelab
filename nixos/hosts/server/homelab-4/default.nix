{ config, ... }:
{
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";

  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11_legacy470;
  hardware.graphics.enable = true;
  hardware.nvidia.datacenter.enable = true;
  services.xserver.videoDrivers = true;
  hardware.nvidia-container-toolkit.enable = true;
  
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };
}
