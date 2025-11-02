{
  pkgs,
  lib,
  ...
}:
#
# The absolute minimum system config required for my nix setup
# Shouldn't be required to use flakes to run this, nor any secrets
# Should be compatible with ALL hosts, including golden images
#
let
  timezone = "Europe/Amsterdam";
in
{

  # ==============================
  # General System Config
  # ==============================
  time.timeZone = timezone;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  users = {
    mutableUsers = false;
  };

  # Auto clean old store files
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # ==============================

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # If we change this things will be sad
  system.stateVersion = "25.05";
  # system.stateVersion = lib.mkDefault lib.trivial.release;
}
