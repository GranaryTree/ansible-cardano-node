{ config, pkgs, ... }:

{
  # Add IOHK's substituters
  # nix.settings = {
  #   substituters = [
  #     "https://cache.nixos.org"
  #     "https://hydra.iohk.io"
  #     "https://iohk-nix-cache.s3-eu-central-1.amazonaws.com/"
  #   ];
  #   # Add IOHK's trusted keys
  #   trusted-public-keys = [
  #     "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
  #     "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #   ];
  # };
}
