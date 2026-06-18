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
    launchOptions = "-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=8";
  };

  # State Version
  system.stateVersion = "25.11";
}