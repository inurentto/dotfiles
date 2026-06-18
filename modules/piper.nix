{ config, pkgs, inputs, lib, ... }:
let
	cfg = config.programs.piper;
in
{
	options.programs.piper = {
		enable = lib.mkEnableOption "Enable Piper";
		package = lib.mkOption {
			type = lib.types.package;
			default = pkgs.piper;
			defaultText = lib.literalExpression;
			description = "Package to use for piper.";
		};
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			cfg.package
		];

		services.ratbagd.enable = true;
	};
}
