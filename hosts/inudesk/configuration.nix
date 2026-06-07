{ config, pkgs, inputs, lib, ... }:

let
  sc0710 = config.boot.kernelPackages.callPackage ../../kernel/sc0710 {};
in
{
  # Module Imports
  imports = [
    ../../modules
  ];

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot = {
    extraModulePackages = [ sc0710 ];
    kernelModules = [ "sc0710" ];
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
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = false;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Environment Variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    VST_PATH = "/run/current-system/sw/lib/vst";
    VST3_PATH = "/run/current-system/sw/lib/vst3";
    LV2_PATH = "/run/current-system/sw/lib/lv2";

    XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT="1";

    XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots";
  };

  # Shell Aliases
  environment.shellAliases = {
    change-wallpaper = "~/.scripts/change-wallpaper.sh";
  };

  # Libraries (Separate into modules)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      libGL
      vulkan-loader

      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXinerama
      xorg.libICE
      xorg.libSM
      libxkbcommon
      libpulseaudio
      libxft

      wayland
      libdecor

      fontconfig
      fontconfig.lib

      dotnetCorePackages.sdk_9_0_1xx-bin
      dotnet-sdk_9
    ];
  };

  # UPower
  services.upower = {
    enable = true;
  };

  # Flatpak
  services.flatpak.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Thunar
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-vcs-plugin
    thunar-volman
    thunar-media-tags-plugin
  ];
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Stream controller
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
    server = { 
      port = 6742;
    };
  };

  # Ratbagd (Piper Dependency)
  services.ratbagd.enable = true;

  # Monado (Rift S VR Support)
  services.monado = {
    enable = false;
    defaultRuntime = true;
    highPriority = true;
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    IPC_EXIT_ON_DISCONNECT = "1";
    WMR_HANDTRACKING = "0";
  };

  # System Packages (Separate into modules)
  environment.systemPackages = with pkgs; [
    openssl
    pkg-config

    dotnetCorePackages.sdk_9_0_1xx-bin
    dotnet-sdk_9
    dotnet-sdk_10

    wget
    zenity

    wineWow64Packages.stable
    winetricks

    bottles

    qpwgraph
    carla
    rnnoise-plugin
    lsp-plugins
    pavucontrol

    piper

    nodePackages.nodejs

    gcc
    gdb
    cmake
    gnumake
    ninja

    wayland
    wayland-protocols
    libxkbcommon
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXext

    cargo
    rustc

    v4l-utils

    jetbrains.clion
    jetbrains.rust-rover

    python3Minimal
    libffi

    freetype

    nwg-look
    gtk3.dev
    gtk4.dev
  ];

  # Ladybird Browser
  programs.ladybird.enable = true;

  # LocalSend
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  # SteamCMD
  programs.steamcmd.enable = true;
}