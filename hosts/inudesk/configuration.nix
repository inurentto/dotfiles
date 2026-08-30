{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		../../modules
	];

	# Nixpkgs
	nixpkgs.overlays = [ inputs.dolphin-overlay.overlays.default ];
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.permittedInsecurePackages = [
		"electron-39.8.10" # Allowed for Discord (Version is EOL)
	];

	# Boot
	boot = {
		kernelPackages = pkgs.linuxPackages_7_1; # Temporary downgrade from latest (Nvidia kernel modules don't compile)
		loader.limine.secureBoot.enable = true;
	};

	# Display Manager
	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
	};

	# Auto Login
	services.displayManager.autoLogin = {
		enable = true;
		user = "inurentto";
	};

	# Graphics
	services.xserver.videoDrivers = ["nvidia"];
	hardware = {
		graphics = {
			enable = true;
			extraPackages = with pkgs; [
				cudaPackages.cuda_opencl
			];
		};
		nvidia = {
			modesetting.enable = true;
			powerManagement.enable = false;
			powerManagement.finegrained = false;
			open = true;
			nvidiaSettings = false;

			package = config.boot.kernelPackages.nvidiaPackages.stable;
		};
		sc0710.enable = true;
	};

	# Environment Variables
	environment.sessionVariables = {
		LIBVA_DRIVER_NAME = "nvidia";
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";
		VST_PATH = "/run/current-system/sw/lib/vst";
		VST3_PATH = "/run/current-system/sw/lib/vst3";
		LV2_PATH = "/run/current-system/sw/lib/lv2";

		XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT="1";

		XDG_CACHE_HOME = "$HOME/.cache";
		XDG_CONFIG_HOME = "$HOME/.config";
		XDG_DATA_HOME = "$HOME/.local/share";
		XDG_STATE_HOME = "$HOME/.local/state";

		XDG_DESKTOP_DIR="$HOME/Desktop";
		XDG_DOWNLOAD_DIR="$HOME/Downloads";
		XDG_PROJECTS_DIR="$HOME/Projects";
		XDG_PICTURES_DIR="$HOME/Pictures";
		XDG_VIDEOS_DIR="$HOME/Videos";
		XDG_SOUNDS_DIR="$HOME/Sounds";
		XDG_MUSIC_DIR="$HOME/Music";
		XDG_DOCUMENTS_DIR="$HOME/Documents";
		XDG_PUBLICSHARE_DIR="$HOME/Public";
		XDG_TEMPLATES_DIR="$HOME/Templates";

		XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots";
	};
	
	# UPower
	services.upower = {
		enable = true;
	};

	# Flatpak
	services.flatpak.enable = true;

	# SSH
	programs.ssh = {
		extraConfig = ''
		Host codeberg.org
			HostName codeberg.org
			User git
			IdentityFile ~/.ssh/id_ed25519_codeberg

		Host github.com
			HostName github.com
			User git
			IdentityFile ~/.ssh/id_ed25519_github
		'';
	};

	# Hyprland
	programs.hyprland = {
		enable = true;
		withUWSM = true;
	};

	# File Manager
	programs.dolphin = {
		enable = true;
		plugins = {
			archives = true;
			network = true;
			fuse = true;
			extras = true;
			admin = true;
		};
		filelight = true;
	};

	# Stream Controller
	programs.streamcontroller.enable = true;

	# Steam
	programs.steam = {
		enable = true;
		gamescopeSession.enable = true;
		protontricks.enable = true;
		extraPackages = with pkgs; [
			posy-cursors
		];
	};

	# OBS Studio
	programs.obs-studio = {
		enable = true;
		enableVirtualCamera = true;
		package = pkgs.obs-studio.override {
			cudaSupport = true;
		};
	};

	# Gamescope
	programs.gamescope.enable = true;

	# OpenRGB
	services.hardware.openrgb = {
		enable = true;
		package = pkgs.openrgb-with-all-plugins;
		motherboard = "intel";
	};

	# Piper
	programs.piper.enable = true;

	# System Packages (Separate into modules)
	environment.systemPackages = with pkgs; [
		# Icon Theme
		papirus-icon-theme

		# GNOME app config editor
		dconf-editor

		# Image Viewer
		kdePackages.gwenview

		# Video & Audio Player
		vlc

		# Wine
		wineWow64Packages.wayland
		winetricks

		# Audio
		qpwgraph
		carla
		rnnoise-plugin
		lsp-plugins

		# Godot
		inputs.godots.packages.${pkgs.stdenv.hostPlatform.system}.default
		godotPackages_4_7.godot

		# Proton Mail
		protonmail-desktop

		# Partition Manager
		kdePackages.partitionmanager

		# Qt Shader Tools
		qt6.qtshadertools

		# Jetbrains
		jetbrains-toolbox

		# Unity
		unityhub
	];

	# I DON'T WANT THIS HERE
	programs.nix-ld = {
    enable = true;
		libraries = with pkgs; [
			# alsa-lib
			# libGL
			# vulkan-loader

			# libx11
			# libxcursor
			# libxext
			# libxfixes
			# libxi
			# libxrandr
			# libxrender
			# libxtst
			# libxinerama
			# libice
			# libsm
			# libxkbcommon
			# libpulseaudio
			# libxft
			# icu

			# wayland
			# libdecor

			# fontconfig
			# fontconfig.lib
		];
	};

	# Devtools
	programs.devtools = {
		enable = true;
		java = {
			enable21 = true;
			enable25 = true;
		};
		javascript = {
			nodejs.enableLts = true;
		};
		c = {
			clang.enable = true;
			cmake = true;
			ninja = true;
		};
		rust = {
			enable = true;
			cargo = true;
		};
		dotnet = {
			enable8 = true;
		};
		godot = {
			v4_6 = false;
			v4_7 = false;
		};
		zig = {
			enableLatest = true;
		};

		packaging = {
			dpkg = true;
		};
	};

	# Ladybird Browser
	programs.ladybird.enable = false;

	# LocalSend
	programs.localsend = {
		enable = true;
		openFirewall = true;
	};

	# Ente Auth
	programs.ente-auth.enable = true;

	# SteamCMD
	programs.steamcmd.enable = true;

	# State Version
	system.stateVersion = "25.11";
}
