{ config, pkgs, ... }:

{
  system.stateVersion = "22.05";

  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
      # ./hardware-builder.nix
      # ./custom-configuration.nix
    ];

  ## Set hostname
  # TODO: better to let Vagrant set hostname later?
  # networking.hostName = "amtadanode";

  # System-wide (all user) packages
  environment.systemPackages = with pkgs; [
    man
    exa
    git

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

  ### Services to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable DBus
  services.dbus.enable    = true;

  # Replace ntpd by timesyncd
  services.timesyncd.enable = true;


  ### Security

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


  ### Add IOHK's substituters
  ## TODO: which to use? subs or trusted-subs? note online indictes
  ## trusted-subs purpuse is to allow untrusted users to install from
  ## trusted srcs
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://hydra.iohk.io"
      "https://iohk-nix-cache.s3-eu-central-1.amazonaws.com/"
    ];
    # trusted-substituters = [
    #   "https://cache.nixos.org"
    #   "https://hydra.iohk.io"
    #   "https://iohk-nix-cache.s3-eu-central-1.amazonaws.com/"
    # ];
    # Add IOHK's trusted keys
    trusted-public-keys = [
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  ### Add vagrant user specs
  users.users.root = { password = "vagrant"; };
# 6/20: does order matter here?  Vagrant grp created w/vagrant user prior
# to vagrant user spec? Should root be in vagrant grp?
# Will vagrant create this user, e.g., can we leave this off & let vagrant create user?
  # Creates a "vagrant" group & user with password-less sudo access
  users.groups.vagrant = {
    name = "vagrant";
    members = [ "vagrant" ];
  };
  users.users.vagrant = {
    # description     = "Vagrant User";
    name            = "vagrant";
    group           = "vagrant";
    extraGroups     = [ "users" "wheel" ];
    password        = "vagrant";
    home            = "/home/vagrant";
    createHome      = true;
    useDefaultShell = true;
    # openssh.authorizedKeys.keys = [
    #       "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
    # ];
    isNormalUser = true;
  };

}
