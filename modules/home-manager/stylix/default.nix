{ config, pkgs, inputs, lib, ... }: {
  options.services.stylix = {
    enable = lib.mkEnableOption "Enable Stylix";
    base16Scheme = lib.mkOption {
      type = lib.types.str;
      default = "ayu-dark";
      description = "https://tinted-theming.github.io/tinted-gallery/";
    };
    image = lib.mkOption {
      type = lib.types.path;
      default = ./wallpaper.png;
      description = "Wallpaper image";
    };
    polarity = lib.mkOption {
      type = lib.types.str;
      default = "dark";
      description = "Light/Dark mode";
    };
    firefox = {
      profileNames = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Firefox profile names, used to style firefox";
      };
    };
  };

  config = lib.mkIf config.services.stylix.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.services.stylix.base16Scheme}.yaml";
    stylix.image = config.services.stylix.image;
    stylix.polarity = config.services.stylix.polarity;
    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };

    stylix.targets.firefox.profileNames = config.services.stylix.firefox.profileNames;
    stylix.targets.firefox.firefoxGnomeTheme.enable = true;
  };
}