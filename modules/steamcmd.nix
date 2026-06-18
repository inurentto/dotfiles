{ config, pkgs, inputs, lib, ... }:
let
	cfg = config.programs.steamcmd;
in
{
	options.programs.steamcmd = {
		enable = lib.mkEnableOption "Enable SteamCMD";
		package = lib.mkOption {
			type = lib.types.package;
			default = pkgs.steamcmd;
			defaultText = "pkgs.steamcmd";
			description = "Package to use for steamcmd.";
		};
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			cfg.package
		];
	};
}
