# configuration.nix
# @niceguy
# auto-last-edit-date-here-would-be-swell-templates-could-be-useful-you-lazy-fuck
{ config, pkgs, ... }:

{
	imports = 
		[

#WARNING: DO NOT TOUCH `./_origin-version.nix` UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING
			./_origin-version.nix

			./hardware-configuration.nix
			(import ./disko.nix { device "/dev/nvme0n1"; })
		];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

}
