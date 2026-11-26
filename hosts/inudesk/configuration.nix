{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		../../modules
	];

	# Nixpkgs
	nixpkgs.config.allowUnfree = true;

	# Boot
	boot = {
		kernelPackages = pkgs.linuxPackages_latest;
		loader.limine.secureBoot.enable = true;
		extraModprobeConfig = ''
			options cfg80211 ieee80211_regdom=SE
		'';
	};

	# Automount
	fileSystems."/run/media/inurentto/Games" = {
		device = "/dev/sda1";
		fsType = "btrfs";
	};
	fileSystems."/run/media/inurentto/Dedicated Servers" = {
		device = "/dev/sdb1";
		fsType = "btrfs";
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

			branch = "stable";
		};
		sc0710.enable = true;
		enableRedistributableFirmware = true;
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

	# Wayland
	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = false;

		extraPortals = with pkgs; [
			inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default
			xdg-desktop-portal-hyprland
			xdg-desktop-portal-gtk
		];

		config.common = {
			default = [ "hyprland" "gtk" ];
			"org.freedesktop.impl.portal.FileChooser" = [ "luciole" "gtk" ];
		};
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

	# Stream Controller
	programs.streamcontroller.enable = true;

	# Steam
	programs.steam = {
		enable = true;
		gamescopeSession.enable = true;
		protontricks.enable = true;
		remotePlay.openFirewall = true;
		extest.enable = true;
		extraPackages = with pkgs; [
			posy-cursors
			hidapi
		];
	};

	# Gamescope
	programs.gamescope.enable = true;

	# OBS Studio
	programs.obs-studio = {
		enable = true;
		enableVirtualCamera = true;
		package = pkgs.obs-studio.override {
			cudaSupport = true;
		};
	};

	# OpenRGB
	services.hardware.openrgb = {
		enable = true;
		package = pkgs.openrgb-with-all-plugins;
		motherboard = "intel";
	};

	# Camera
	programs.droidcam.enable = true;

	# System Packages (Separate into modules)
	environment.systemPackages = with pkgs; [
		# File Manager
		inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default

		# Notifications
		libnotify

		# Media Player Control
		playerctl

		# Screenshot
		grimblast
		hyprpicker

		# Encryption
		openssl
		libargon2

		# GNOME app config editor
		dconf-editor

		# Wine
		wineWow64Packages.wayland
		winetricks

		# Audio
		qpwgraph
		carla

		# Audio Plugins
		rnnoise-plugin
		lsp-plugins
		vital

		# Steam Frame
		iw
	];

	# I DON'T WANT THIS HERE
	# Most of this is needed for minecraft (prism-launcher)
	programs.nix-ld = {
    	enable = true;
		libraries = with pkgs; [
			# X11
			libx11
			libxcursor
			libxext
			libxfixes
			libxi
			libxrandr
			libxrender
			libxtst
			libxinerama
			libice
			libsm
			libxkbcommon
			libpulseaudio
			libxft

			# Wayland
			wayland
			libdecor

			# OpenGL & Vulkan
			libGL
			vulkan-loader

			# Audio
			pipewire
			alsa-lib

			# Unicode
			icu

			# Fonts
			fontconfig
			fontconfig.lib
		];
	};

	# LocalSend
	programs.localsend = {
		enable = true;
		openFirewall = true;
	};

	# Ente Auth
	programs.ente-auth.enable = true;

	# SteamCMD
	programs.steamcmd.enable = true;

	# Virtual Machines
	virtualisation.libvirtd = {
		enable = true;
	};
	programs.virt-manager.enable = true;

	# State Version
	system.stateVersion = "25.11";
}
