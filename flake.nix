# flake.nix
#
# description: flake.nix file
# @niceguy

{
	description = "NixOS flake config";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {nixpkgs, ...} @ inputs:
	{
		nixosConfigurations.default = nixpkgs.lib.nixosSystem {
			specialArgs = {inherit inputs;};
			modules = [
				inputs.disko.nixosModules.default
				(import ./disko.nix { device = "/dev/nvme0n1"; })

				./configuration.nix
			];
		};
	};
}
