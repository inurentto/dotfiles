{ config, lib, pkgs, ... }:
let
	cfg = config.services.satisfactory-server;
in
{
	options.services.satisfactory-server = {
		enable = lib.mkEnableOption "Satisfactory Dedicated Server";

		steamcmdPackage = lib.mkOption {
			type = lib.types.package;
			default = pkgs.steamcmd;
			defaultText = lib.literalExpression "pkgs.steamcmd";
			description = "Package to use for steamcmd.";
		};

		steamrunPackage = lib.mkOption {
			type = lib.types.package;
			default = pkgs.steam-run;
			defaultText = lib.literalExpression "pkgs.steam-run";
			description = "Packages to use for steam-run.";
		};

		dataDir = lib.mkOption {
			type = lib.types.path;
			description = "Directory to store the game server to.";
			default = "/var/lib/satisfactory";
		};

		openFirewall = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to open firewall ports for the server.";
		};

		experimental = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to use the experimental branch or not.";
		};

		maxPlayers = lib.mkOption {
			type = lib.types.ints.u8;
			default = 4;
			description = "The max amount of players to allow on the server.";
		};

		extraLaunchOptions = lib.mkOption {
			type = lib.types.str;
			default = "";
			description = "Extra launch options to use. Use {option}`services.satisfactory-server.maxPlayers` to change the max allowed amount of players.";
		};
	};

	config = lib.mkIf cfg.enable {

		systemd.services.satisfactory-server =
			let
				steamcmd = "${cfg.steamcmdPackage}/bin/steamcmd";
				steam-run = "${cfg.steamrunPackage}/bin/steam-run";
				beta-branch = if cfg.experimental then "-beta experimental " else "";
				max-players-option = if cfg.maxPlayers != 4 then "-ini:Game:[/Script/Engine.GameSession]:MaxPlayers=${cfg.maxPlayers} " else ""; # Satisfactory has a default cap of 4 players, hence lanuch option is not always needed.
			in {
				description = "Satisfactory Dedicated Server";
				wantedBy = [ "multi-user.target" ];
				after = [ "network.target" ];

				serviceConfig = {
					TimeoutSec = "15min";
					ExecStart =
						"${steam-run} ${cfg.dataDir}/FactoryServer.sh ${max-players-option}${cfg.extraLaunchOptions}";
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
		users.groups.satisfactory = {};

		networking.firewall = lib.mkIf cfg.openFirewall {
				allowedTCPPorts = [ 7777 8888 ];
				allowedUDPPorts = [ 7777 ];
			};
	};
}
