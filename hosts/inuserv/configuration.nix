{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules
  ];

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Network
  networking.hostName = "inudesk";

  # SSH
  services.openssh.enable = true;
}