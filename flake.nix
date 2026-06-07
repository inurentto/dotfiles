{
  description = "NixOS System";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww.url = "git+https://codeberg.org/LGFae/awww";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base16.url = "github:SenchoPens/base16.nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixcord.url = "github:FlameFlag/nixcord";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    let
      mkSystem = { system, hostname }: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;

            environment.shellAliases = {
              rebuild-nixos = "sudo nixos-rebuild switch --flake ~/.config/nixos#${hostname}";
              cleanup-nixos = "sudo nix-collect-garbage --delete-old";
            };
          }

          (./. + "/hosts/${hostname}/configuration.nix")
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
          inputs.home-manager.nixosModules.home-manager {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = false;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users.inurentto = (./. + "/hosts/${hostname}/home.nix");
            };
          }

          inputs.nur.modules.nixos.default
        ];
      };
  in {
    nixosConfigurations = {
      inudesk = mkSystem { system = "x86_64-linux"; hostname = "inudesk"; };
      inuserv = mkSystem { system = "x86_64-linux"; hostname = "inuserv"; };
    };
  };
}
