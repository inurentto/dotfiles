{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules/home-manager
  ];

  # Home Manager
  home.username = "inurentto";
  home.homeDirectory = "/home/inurentto";
  home.stateVersion = "25.11";
}