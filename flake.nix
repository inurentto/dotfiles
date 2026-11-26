{
	description = "NixOS System";

	inputs = {
		# Nix Packages & Config
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Kernel Modules
		sc0710.url = "github:Nakildias/sc0710";

		# Apps
		nixcord = {
			url = "github:4evy/nixcord";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		luciole = {
			url = "github:noctalia-dev/luciole";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Shell
		inu-shell = {
			url = "github:inurentto/inushell-mirror";
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
							update-nixos-hardware = "sudo nixos-generate-config --dir ~/.config/nixos/hosts/${hostname}";
							update-nixos-flake = "sudo nix flake update --flake ~/.config/nixos";
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
				];
			};
	in {
		nixosConfigurations = {
			inudesk = mkSystem { system = "x86_64-linux"; hostname = "inudesk"; };
			inuserv = mkSystem { system = "x86_64-linux"; hostname = "inuserv"; };
		};
	};
}
