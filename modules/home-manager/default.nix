{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.base16.homeManagerModule
    inputs.spicetify-nix.homeManagerModules.spicetify
    inputs.nixcord.homeModules.nixcord
    
    ./hyprland
    ./stylix
  ];

  # Environment Variables
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Fastfetch
  programs.fastfetch.enable = true;

  # Btop
  programs.btop.enable = true;
}