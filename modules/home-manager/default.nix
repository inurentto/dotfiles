{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		inputs.nixcord.homeModules.nixcord
	];

	# User
	home.username = "inurentto";
	home.homeDirectory = "/home/inurentto";

	# Terminal Shell
	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting
		'';
		plugins = [];
	};
	programs.oh-my-posh = {
		enable = true;
		enableFishIntegration = true;
		settings = {
			final_space = true;

			blocks = [
				{
					type = "prompt";
					alignment = "left";
					segments = [
						{
							type = "os";
							style = "powerline";
							template = "<darkGray,transparent></>{{ .Icon }} <darkGray,transparent></>";
							foreground = "foreground";
							background = "darkGray";
						}
					];
				}
				{
					type = "prompt";
					alignment = "left";
					segments = [
						{
							type = "nix-shell";
							style = "powerline";
							template = "<blue,transparent></> {{ .Type }} <blue,transparent></>";
							foreground = "black";
							background = "blue";
						}
					];
				}
				{
					type = "prompt";
					alignment = "left";
					segments = [
						{
							type = "path";
							style = "powerline";
							template = "<yellow,transparent></> {{ .Path }} <yellow,transparent></>";
							foreground = "black";
							background = "yellow";
							options = {
								style = "full";
							};
						}
					];
				}

				{
					segments = [
						{
							foreground = "darkGray";
							template = " {{ .CurrentDate | date .Format }} ";
							options = {
								time_format = "15:04:05";
							};
							style = "plain";
							type = "time";
						}
					];
					type = "rprompt";
				}
			];
		};
	};

	# Environment Variables
	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
	};

	# Fastfetch
	programs.fastfetch.enable = true;

	# Btop
	programs.btop = {
		enable = true;
		package = pkgs.btop.override {
      cudaSupport = true;
    };
	};

	# Hyprland (not enabled by default)
	wayland.windowManager.hyprland = {
		xwayland.enable = lib.mkDefault true;
		systemd.enable = lib.mkDefault true;
		systemd.variables = lib.mkDefault [ "--all" ];

		configType = "lua";

		extraLuaFiles = {
			"default" = {
				content = ./hyprland/hyprland.lua;
				autoLoad = true;
			};
			"vars" = {
				content = ./hyprland/vars.lua;
				autoLoad = false;
			};
		};
	};

	programs.alacritty.settings = {
		terminal = {
			shell = "fish";
		};
		window = {
			padding = {
				x = 8;
				y = 8;
			};
			dynamic_padding = true;
			decorations = "None";
			opacity = 0.9;
		};
		cursor = {
			style = {
				shape = "Beam";
				blinking = "On";
			};
		};
	};
}
