# flake.nix
#
# description: flake.nix file
# @niceguy
# Flakes is a feature of managing Nix packages to simplify usability and improve reproducibility of Nix installations. Flakes manages dependencies between Nix expressions, which are the primary protocols for specifying packages. Flakes implements these protocols in a consistent schema with a common set of policies for managing packages.
#   https://nixos.wiki/wiki/Flakes
{
  description = "NixOS flake config";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence = {
    #   url = "github:nix-community/impermanence";
    # };

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {nixpkgs, ...} @ inputs:
  {
    nixosConfigurations.copycat = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.disko.nixosModules.copycat
        (import ./disko.nix { device = "/dev/nvme0n1"; })

        ./configuration.nix
              
        # inputs.home-manager.nixosModules.default # default should be copycat
        # inputs.impermanence.nixosModules.impermanence
      ];
    };
  };
}
