{ config, pkgs, ... }:

{
  system.stateVersion = "22.05";

  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
      # ./hardware-builder.nix
      ./vagrant.nix
      ./iohk.nix
      ./custom-configuration.nix
    ];

  # System-wide (all user) packages
  environment.systemPackages = with pkgs; [
    man
    exa

    # Packages for Vagrant
    findutils
    gnumake
    iputils
    jq
    nettools
    netcat
    nfs-utils
    rsync

    python3   # Ansible needs python
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  # Services to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable DBus
  services.dbus.enable    = true;

  # Replace ntpd by timesyncd
  services.timesyncd.enable = true;

  security.sudo.extraConfig =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

  # Add IOHK's substituters
  ## DIDN'T WORK: environment, nix
  config = {
    substituters = [
      "https://cache.nixos.org"
      "https://hydra.iohk.io"
      "https://iohk-nix-cache.s3-eu-central-1.amazonaws.com/"
    ];
    # Add IOHK's trusted keys
    trusted-public-keys = [
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
