# configuration.nix
# @niceguy
# auto-last-edit-date-here-would-be-swell-templates-could-be-useful-you-lazy-fuck
# unsure how flake.nix really works - but it seems that it comes before the config file - disk config is there.
#
# /static
#
# my system(s? eventually), will have a /static directory, this is basically 'data', a logical, cental 
# point for all mutable data.
# 
# good place for a home directory, no?
# 
# thus: /static/u/niceguy
#   = /static/ (data) -> u/ (users) -> name (name of user)
#
#
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

		# As much as I think I would prefer to use systemd on principle
		# Being able to do "nixos-rebuild switch -p test" to make a new profile/submenu is actually pretty dope... 
		# test this now ...
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		time.timeZone = "Pacific/Auckland";
		i18n.defaultLocale = "en_NZ.UTF-8";

		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		networking.hostName = "copycat";

#		This left here as an example of including more hosts entries
#		networking.extraHosts = ''
#			127.0.0.2 other-localhost 
#		'';

		services.openssh.enable = true;

		# Scary! lets see how she handles it
		# 
		#	Automatic Upgrades

		# You can keep a NixOS system up-to-date automatically by adding the following to configuration.nix:

		system.autoUpgrade.enable = true;
		system.autoUpgrade.allowReboot = false;

		# This enables a periodically executed systemd service named nixos-upgrade.service. If the allowReboot option is false, it runs nixos-rebuild switch --upgrade to upgrade NixOS to the latest version in the current channel. (To see when the service runs, see systemctl list-timers.) If allowReboot is true, then the system will automatically reboot if the new generation contains a different kernel, initrd or kernel modules. You can also specify a channel explicitly, e.g.

		# system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";

		programs.hyprland.enable = true;

		environment.systemPackages = with pkgs; [
			vim
		];


# full example - 10d on the end is clean up age- need to find out more about this - tmpfiles.d
#		[
#			"d /tmp/poo 1111 niceguy users 10d"
#		]
		# DIRECTORIES
		# worth noting this will only be used for creation...
		systemd.tmpfiles.rules = [
			"d /static 755 root users"
			"d /static/u 755 root users"
			"d /static/data 755 niceguy users"
		]


		users.users."niceguy" = {
			isNormalUser = true;
			# TODO: currently it doesn't make the directory...
			home = "/static/u/niceguy/";
			description = "NiceGuy";
			initialPassword = "1";
			# hashedPassword = ".kpKfkdtYvszg"; # creatable with mkpasswd (currently: 'init') - unsure of algorithm - doesnt seem to be md5
			# format for it seems incorrect atm - need to check.
			extraGroups = [ "wheel" "networkmanager" ];
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
