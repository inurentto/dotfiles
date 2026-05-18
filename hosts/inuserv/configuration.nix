{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules
  ];

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # SSH
  services.openssh.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [];

  # SteamCMD
  programs.steamcmd.enable = true;

  # Satisfactory
  services.satisfactory-server = {
    enable = true;
    openFirewall = true;
    experimental = true;
  };
}