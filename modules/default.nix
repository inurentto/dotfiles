{ config, pkgs, inputs, lib, ... }: {
  # Remove unecessary preinstalled packages
  environment.defaultPackages = [ ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Package Overrides
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };

  # Module Imports
  imports = [
    ./steamcmd
    ./satisfactory
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    zip
    unzip

    wl-clipboard

    gh
    
    appimage-run

    pulseaudio

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
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    loader = {
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Wayland
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
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

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

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

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Users
  users.users = {
    inurentto = {
      isNormalUser = true;
      description = "inurentto";
      extraGroups = [ "networkmanager" "wheel" "input" ];
    };
  };

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

  # State Version
  system.stateVersion = "25.11";
}