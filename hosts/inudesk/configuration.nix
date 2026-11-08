{ config, pkgs, inputs, lib, ... }: {
	# Module Imports
	imports = [
		../../modules
	];

	# Nixpkgs
	nixpkgs.config.allowUnfree = true;

	# Boot
	boot = {
		kernelPackages = pkgs.linuxPackages_7_2;
		loader.limine.secureBoot.enable = true;
	};

	# Automount
	fileSystems."/run/media/inurentto/Games" = {
		device = "/dev/sdb1";
		fsType = "btrfs";
	};
	fileSystems."/run/media/inurentto/Dedicated Servers" = {
		device = "/dev/sda1";
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

			# config.boot.kernelPackages.nvidiaPackages.stable;
			# Temporary custom nvidia driver module because the one from nix doesn't have linux 7.2 support
			package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
				version = "610.57.04";
				sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
				sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
				openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
				settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
				persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
			};
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
	programs.streamcontroller.enable = false; # Temp move to flatpak because of python tests failing in latest version due to deprication

	# Steam
	programs.steam = {
		enable = true;
		gamescopeSession.enable = true;
		protontricks.enable = true;
		extest.enable = true;
		extraPackages = with pkgs; [
			posy-cursors
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
