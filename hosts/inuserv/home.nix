{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules/home-manager
  ];

  # State Version
  home.stateVersion = "25.11";
}