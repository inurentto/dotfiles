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

  # System Packages
  # environment.systemPackages = with pkgs; [];

  # SteamCMD
  programs.steamcmd.enable = true;

  # Satisfactory
  services.satisfactory-server = {
    enable = false;
    openFirewall = true;
    experimental = false;
    maxPlayers = 8;
  };

  # Java
  programs.devtools = {
		enable = true;
		java.enable25 = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  # State Version
  system.stateVersion = "25.11";
}