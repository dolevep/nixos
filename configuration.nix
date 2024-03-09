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


		# NixOS SETTINGS
		nix.settings.experimental-features = [ "nix-command" "flakes" ];


		# BOOTLOADER
		# As much as I think I would prefer to use systemd on principle
		# Being able to do "nixos-rebuild switch -p test" to make a new profile/submenu is actually pretty dope... 
		# test this now ...
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		# KERNEL
		boot.kernelPackages = pkgs.linuxPackages_zen;


		# LOCALE/LOCALIZATION
		time.timeZone = "Pacific/Auckland";
		i18n.defaultLocale = "en_NZ.UTF-8";

# # GPU SHIT WILL NEED TO HAPPEN SADGEGEGEGEEEEEEE
# 		hardware.opengl.extraPackages = [
# 			rocmPackages.clr.icd
# 		];
# # well that was hard ... does it actually work? it should enable OpenCL support

		# NETWORKING
		networking.hostName = "copycat";
#		This left here as an example of including more hosts entries
#		networking.extraHosts = ''
#			127.0.0.2 other-localhost 
#		'';
		networking.networkmanager.enable = true;
		networking.firewall.enable = true;
		# networking.firewall.allowedTCPPorts = [ 22 ];
		# networking.firewall.allowTCPPortRanges = [
		# 	{ from = 69; to 169; }
		# ];
		services.openssh.enable = true; # this automatically opens port 22 which we explicitly open above just for examples sake
		services.openssh = {
			enable = true;
			settings.PasswordAuthentication = false;
			settings.KbdInteractiveAuthentication = false;
			settings.PermitRootLogin = "no";
		};

		# WIRELESS
		networking.wireless.networks = {
			CHANGE_ME_TO_SSD = { # update this to SSID
				psk = "f3fbcbb759925b159da64c042dcb6d8da4c26ebdd042bf844a68a011270c1375"; # can use wpa_passphrase to change this
			};
			free.wifi = {};
		};


		#	AUTOMATIC UPDATES
		# Scary! lets see how she handles it
		# You can keep a NixOS system up-to-date automatically by adding the following to configuration.nix:
		system.autoUpgrade.enable = true;
		system.autoUpgrade.allowReboot = false;
		# This enables a periodically executed systemd service named nixos-upgrade.service. If the allowReboot option is false, it runs nixos-rebuild switch --upgrade to upgrade NixOS to the latest version in the current channel. (To see when the service runs, see systemctl list-timers.) If allowReboot is true, then the system will automatically reboot if the new generation contains a different kernel, initrd or kernel modules. You can also specify a channel explicitly, e.g.
		# system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";


		# DIRECTORY SETUP
		# run systemd-tmpfiles --clean to remove superfluous files
		# 
		# worth noting this will only be used for creation/updating automagically - it will create new in place what it says (meaning it will overwrite permissions but its not moving the directory), will also not remove anything without a clean
		systemd.tmpfiles.rules = [
			"d /static 755 root users ~7d"	# holds data within /static for 7d, will NOT remove files/directories immediately inside
			"d /static/u 755 root users"
		];
#			DO NOT ADD UNLESS YOU'RE ACTIVELY USING SHIT, BE EXPLICIT, BE PURPOSEFUL
#			EXAMPLES: 
#			"d /static/testing 755 niceguy users 30s" # 30second hold time for testing - could be some interesting applications to this...
#			"d /static/data 755 niceguy users"
#			"d /static/transient 777 niceguy users 1d" # conceptually use this for downloading rando source for compliation and testing etc

		# SYSTEM PACKAGES
		programs.sway.enable = true;
		programs.hyprland.enable = true;


		environment.systemPackages = with pkgs; [
			vim
			git
			home-manager
		];


		# USER SETUP
		users.users."niceguy" = {
			isNormalUser = true;
			# TODO: currently it doesn't make the directory...
			home = "/static/u/niceguy/";
			shell = pkgs.zsh;
			description = "NiceGuy";
#			initialPassword = "1";
			initialPassword = ''\'';
			# hashedPassword = ".kpKfkdtYvszg"; # creatable with mkpasswd (currently: 'init') - unsure of algorithm - doesnt seem to be md5
			# format for it seems incorrect atm - need to check.
			extraGroups = [ "wheel" "networkmanager" ];
			packages = with pkgs; [
				neovim
				kitty
				qutebrowser
				dunst
				wofi
			];
			openssh.authorizedKeys.keys = [
				"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcSxgkHz5dLJzOwVP8+FgbGjJXpitT/jfA8vWW+9TX3WudWqFFbXdVji5kB7ogSdVNYFZEvvZE9Qul84CClalDHhHFeGCBvudVnDC0pe2z1X7XktZLF957DUAPpGS6nI8n7uwc3eCKLIck1GZiJdE5I0U7CMvoMaXS94RisdxuogQCD+osnrbJa7lIBYHRyuMG1TNoxJ+w5CRkFFbJMViXQERD6OpJGSBmHhehuM/ek6mgi0P8jJ5HI9rNn2ulOIfoU3RdheWV32NtnjtvJ68Zas9n4osREh934z0fO2swT6xHvqyKv3am2D3TENTctt/IHSy6KhbvppfA2EFywkkGXp52QugIX5MVYSmUbZUZcDent2+eOAgHdCMYve+N588QNa9m7lq+7GQUVBKXdjogsVLzJkZCY5z8LkNTRtOZ8vA1VO4Lm1mVmHipma5zhHR3eXoV0fAuzd1kGpHAefOsByLa9wPDexyHcCiou/XQD3pAYKRnlxOet1gjLFZBQVc= twe"
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
