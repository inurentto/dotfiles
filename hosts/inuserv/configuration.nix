{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules
  ];

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # SSH
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "inurentto" ];
    };
  };

  # Tmux
  programs.tmux.enable = true;

  # SteamCMD
  programs.steamcmd.enable = true;

  # Satisfactory
  services.satisfactory-server = {
    enable = true;
    openFirewall = true;
    experimental = false;
    maxPlayers = 8;
  };

  environment.systemPackages = with pkgs; [
    jdk21
  ];

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 24454 ];
  };

  # State Version
  system.stateVersion = "25.11";
}