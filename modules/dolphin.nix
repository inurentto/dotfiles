{ config, pkgs, inputs, lib, ... }:
let
	cfg = config.programs.dolphin;
in
{
	options.programs.dolphin = {
		enable = lib.mkEnableOption "Enable the Dolphin file manager by KDE.";
		package = lib.mkOption {
			type = lib.types.package;
			default = pkgs.kdePackages.dolphin;
			defaultText = "pkgs.kdePackages.dolphin";
			description = "Package to use for dolphin.";
		};
		plugins = {
			archives = lib.mkEnableOption "Enable archive support. (ark)";
			network = lib.mkEnableOption "Enable network shares. (kio)";
			fuse = lib.mkEnableOption "Enable fuse shares. (kio-fuse)";
			extras = lib.mkEnableOption "Enable extras. (kio-extras)";
			admin = lib.mkEnableOption "Enable admin actions. (kio-admin)";
		};
		filelight = lib.mkEnableOption "Enable Filelight.";
	};

	config = lib.mkIf cfg.enable {
		environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
		environment.systemPackages = with pkgs; [
			cfg.package
			kdePackages.dolphin-plugins
			kdePackages.qtsvg
			kdePackages.kde-cli-tools

			(lib.mkIf cfg.plugins.archives kdePackages.ark)
			(lib.mkIf cfg.plugins.network kdePackages.kio)
			(lib.mkIf cfg.plugins.fuse kdePackages.kio-fuse)
			(lib.mkIf cfg.plugins.extras kdePackages.kio-extras)
			(lib.mkIf cfg.plugins.admin kdePackages.kio-admin)

			(lib.mkIf cfg.filelight kdePackages.filelight)
		];

		services.gvfs.enable = cfg.plugins.network;
		services.udisks2.enable = true; # Disk Mounting
	};
}
