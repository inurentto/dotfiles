{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules
  ];

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Automount
  fileSystems."/run/media/inurentto/External" = {
		device = "/dev/sda1";
		fsType = "ext4";
	};

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

  # Firewall
  networking.firewall = {
    allowedTCPPorts = [
      25565 # Minecraft
    ];
    allowedUDPPorts = [
      25565 # Minecraft
      24454 # Minecraft Simple Voice Chat
    ];
  };

  # State Version
  system.stateVersion = "25.11";
}