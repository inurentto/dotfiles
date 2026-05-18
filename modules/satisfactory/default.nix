{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.satisfactory-server;
in
{
  options.services.satisfactory-server = {
    enable = mkEnableOption "Satisfactory Dedicated Server";

    steamcmdPackage = mkOption {
      type = types.package;
      default = pkgs.steamcmd;
      defaultText = "pkgs.steamcmd";
      description = "The package implementing SteamCMD";
    };

    steamrunPackage = mkOption {
      type = types.package;
      default = pkgs.steam-run;
      defaultText = "pkgs.steam-run";
      description = "The package implementing steam-run";
    };

    dataDir = mkOption {
      type = types.path;
      description = "Directory to store game server";
      default = "/var/lib/satisfactory";
    };

    launchOptions = mkOption {
      type = types.str;
      description = "Launch options to use.";
      default = "";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open ports in the firewall for the server";
    };

    experimental = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use the experimental branch or not."
    }
  };

  config = mkIf cfg.enable {

    systemd.services.satisfactory-server =
      let
        steamcmd = "${cfg.steamcmdPackage}/bin/steamcmd";
        steam-run = "${cfg.steamrunPackage}/bin/steam-run";
        beta-branch = if cfg.experimental true then "-beta experimental " else ""
      in {
        description = "Satisfactory Dedicated Server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          TimeoutSec = "15min";
          ExecStart =
            "${steam-run} ${cfg.dataDir}/FactoryServer.sh ${cfg.launchOptions}";
          Restart = "always";
          User = "satisfactory";
          WorkingDirectory = cfg.dataDir;
        };

        preStart = ''
          ${steamcmd} +force_install_dir "${cfg.dataDir}" +login anonymous +app_update 1690800 ${beta-branch}validate +quit
        '';
      };

    users.users.satisfactory = {
      description = "Satisfactory server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "satisfactory";
    };
    users.groups.satisfactory = { };

    networking.firewall =
      mkIf cfg.openFirewall {
        allowedTCPPorts = [ 7777 8888 ];
        allowedUDPPorts = [ 7777 ];
      };
  };
}
