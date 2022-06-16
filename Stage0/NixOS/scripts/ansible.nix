{ config, pkgs, ... }:

{
  # Packages for Ansible
  environment.systemPackages = with pkgs; [
    python3   # Ansible needs python
  ];

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


# Place here any custom configuration specific to your organisation (locale, ...)
# if you want it to be part of the packer base image to be used with vagrant.
}
