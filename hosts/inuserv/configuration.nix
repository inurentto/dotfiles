{ config, pkgs, inputs, lib, ... }: {
  # Module Imports
  imports = [
    ../../modules
  ];

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Environment
  environment.shellAliases = {
    rebuild-nixos = "sudo nixos-rebuild switch --impure --flake ~/.config/nixos#inuserv";
    cleanup-nixos = "sudo nix-collect-garbage --delete-old";
  };

  # SSH
  services.openssh.enable = true;
}