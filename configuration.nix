# configuration.nix
# @niceguy
# auto-last-edit-date-here-would-be-swell-templates-could-be-useful-you-lazy-fuck
# unsure how flake.nix really works - but it seems that it comes before the config file - disk config is there.
#WARNING: DO NOT TOUCH `./_origin-version.nix` UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING

{ pkgs, lib, inputs, ... }:

{
	imports = 
		[
			# disks presumably handled by flake and disko via flake.nix 
			# prior to this. but doesn't need imported?
			./_origin-version.nix
			./hardware-configuration.nix
#			./niceguy.nix # todo 
		];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		time.timeZone = "Pacific/Auckland";
		i18n.defaultLocale = "en_NZ.UTF-8";

		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		services.openssh.enable = true;

		programs.hyprland.enable = true;

		users.users."niceguy" = {
			isNormalUser = true;
			description = "niceguy";
			initialPassword = "1";
			extraGroups = [ "wheel" ];
			packages = with pkgs; [
				vim
				neovim
				kitty
				dunst
				wofi
				xwayland
				hyprland
			];
		};

		#WARNING:
	# IF I WANT TO DO IMPERMANENCE THIS WILL BE NEEDED - DISKS ARE SET UP FOR IT ... I THINK ...
	# REVIEW BEFORE IMPLEMENTING BLINDLY
	# SERIOUSLY, DONT BE AN IDIOT
	# ...
	# GODDAMNIT I KNOW YOU
	# ...
	# listen
	# ..
	# pls
	# .
	#
	# 	boot.initrd.postDeviceCommands = lib.mkAfter ''
	# 		mkdir /btrfs_tmp
	# 	  mount /dev/copycat/root /btrfs_tmp
	#     if [[ -e /btrfs_tmp/root ]]; then
	# 				mkdir -p /btrfs_tmp/old_roots
	# 			  timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
	# 		    mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
	# 	  fi
	#
	#     delete_subvolume_recursively() {
	# 			  IFS=$'\n'
	# 		    for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
	# 	          delete_subvolume_recursively "/btrfs_tmp/$i"
	#         done
	# 		    btrfs subvolume delete "$1"
	# 	  }
	#
	#     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
	# 		    delete_subvolume_recursively "$i"
	# 	  done
	# 
	#     btrfs subvolume create /btrfs_tmp/root
	# 		umount /btrfs_tmp
	# 	'';
	#
		#WARNING:
	# IF I WANT TO DO IMPERMANENCE THIS WILL BE NEEDED - DISKS ARE SET UP FOR IT ... I THINK ...

}
