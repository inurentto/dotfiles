{ config, pkgs, inputs, lib, ... }: {
  options.programs.steamcmd = {
    enable = lib.mkEnableOption "Enable SteamCMD";
  };

  config = lib.mkIf config.programs.steamcmd.enable {
    environment.systemPackages = [
      pkgs.steamcmd
    ];
  };
}