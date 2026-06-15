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
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10" # Allowed for Discord (Version is EOL)
  ];

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

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
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
  programs.thunar.plugins = with pkgs; [
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

    jdk21
    jdk25

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

    nodejs

    gcc
    gdb
    cmake
    gnumake
    ninja

    wayland
    wayland-protocols
    libxkbcommon
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxext

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