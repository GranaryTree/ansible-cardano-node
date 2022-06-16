# This file is overwritten by the vagrant-nixos plugin
{ config, pkgs, ... }:
{
  imports = [
    ./vagrant-hostname.nix
    ./vagrant-network.nix
  ];

  # Packages for Vagrant
  config = {
    environment.systemPackages = with pkgs; [
      findutils
      gnumake
      iputils
      jq
      nettools
      netcat
      nfs-utils
      rsync
    ];
  };

  users.users.root = { password = "vagrant"; };
  # Creates a "vagrant" group & user with password-less sudo access
  users.groups.vagrant = {
    name = "vagrant";
    members = [ "vagrant" ];
  };
  users.users.vagrant = {
    description     = "Vagrant User";
    name            = "vagrant";
    group           = "vagrant";
    extraGroups     = [ "users" "wheel" ];
    password        = "vagrant";
    home            = "/home/vagrant";
    createHome      = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
    ];
    isNormalUser = true;
  };

}
