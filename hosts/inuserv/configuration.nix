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
    enable = false;
    openFirewall = true;
    experimental = false;
    maxPlayers = 8;
  };

  # State Version
  system.stateVersion = "25.11";
}