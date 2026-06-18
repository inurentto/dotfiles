{ config, pkgs, inputs, lib, ... }: {
	# Remove unecessary preinstalled packages
	environment.defaultPackages = [ ];
	services.xserver.excludePackages = [ pkgs.xterm ];

	# Module Imports
	imports = [
		inputs.sc0710.nixosModules.default

		./dolphin.nix
		./devtools.nix
		./piper.nix
		./steamcmd.nix
		./satisfactory.nix
	];

	# Packages
	environment.systemPackages = with pkgs; [
		sbctl

		zip
		unzip

		pax-utils
		nix-index

		wl-clipboard

		gh
		codeberg-cli

		appimage-run

		pulseaudio
		pipewire.jack

		efibootmgr

		lm_sensors
	];

	# Nix
	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;
			allowed-users = [ "inurentto" ];
		};

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 7d";
		};
	};
	programs.nix-ld.enable = true;

	# Boot
	boot = {
		kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
		tmp.cleanOnBoot = true;
		loader = {
			limine.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};

	# Terminal Shell
	programs.fish.enable = true;

	# Wayland
	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;

		extraPortals = with pkgs; [
			xdg-desktop-portal-hyprland
			xdg-desktop-portal-gtk
		];

		config = {
			common = {
				default = "hyprland;gtk";
			};

			kde = {
				default = "kde";
			};

			"org.freedesktop.impl.portal.FileChooser" = {
				default = "kde";
			};
		};
	};

	# X11
	services.xserver = {
		enable = true;
		xkb = {
			layout = "se";
			variant = "";
		};
	};

	# Environment Variables
	environment.variables = {

	};
	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		QT_QPA_PLATFORMTHEME = "qt6ct";
	};

	# Keyring & Security
	services.gnome.gnome-keyring.enable = true;
	security.pam.services.sddm.enableGnomeKeyring = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
		enableBrowserSocket = true;
	};

	# Networking
	networking = {
		networkmanager.enable = true;
		firewall = {
			allowedTCPPorts = [];
			allowedUDPPorts = [];
		};
	};

	# Bluetooth
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = {
			General = {
				Experimental = true;
				FastConnectable = true;
			};
			Policy = {
				AutoEnable = true;
			};
		};
	};

	# Sound
	services.pulseaudio.enable = false;
	services.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		jack.enable = true;
	};
	security.rtkit.enable = true;

	# Power Profiles
	services.power-profiles-daemon.enable = true;

	# Printing
	services.printing.enable = true;

	# Locales
	time.timeZone = "Europe/Stockholm";
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "sv_SE.UTF-8";
			LC_IDENTIFICATION = "sv_SE.UTF-8";
			LC_MEASUREMENT = "sv_SE.UTF-8";
			LC_MONETARY = "sv_SE.UTF-8";
			LC_NAME = "sv_SE.UTF-8";
			LC_NUMERIC = "sv_SE.UTF-8";
			LC_PAPER = "sv_SE.UTF-8";
			LC_TELEPHONE = "sv_SE.UTF-8";
			LC_TIME = "sv_SE.UTF-8";
		};
	};
	console.keyMap = "sv-latin1";

	# Users
	users.users = {
		inurentto = {
			isNormalUser = true;
			description = "inurentto";
			extraGroups = [ "networkmanager" "wheel" "input" ];
		};
	};

	# Fonts
	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		nerd-fonts.profont
		inter
	];

	# Direnv
	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};

	# Git
	programs.git = {
		enable = true;
		lfs.enable = true;
	};

	# VPN
	services.mullvad-vpn.enable = true;
}
