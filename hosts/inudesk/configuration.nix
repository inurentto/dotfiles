{ config, pkgs, inputs, ... }: {
  # Module Imports
  imports = [
    ../../modules
  ];

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
  nixpkgs.config.allowUnfree = true;

  # Environment Variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    VST_PATH = "/run/current-system/sw/lib/vst";
    VST3_PATH = "/run/current-system/sw/lib/vst3";
    LV2_PATH = "/run/current-system/sw/lib/lv2";
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

  # Flatpak
  services.flatpak.enable = true;

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

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

  # System Packages (Separate into modules)
  environment.systemPackages = with pkgs; [
    dotnetCorePackages.sdk_9_0_1xx-bin
    dotnet-sdk_9

    wineWow64Packages.stable
    wineWow64Packages.waylandFull
    wine64
    wineWowPackages.stable
    wineWowPackages.waylandFull
    wine

    qjackctl
    carla
    rnnoise-plugin
    lsp-plugins
    pulseaudio

    piper
  ];
}