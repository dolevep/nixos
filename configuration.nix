imports = [ ./hardware-configuration.nix ];
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
networking.hostName = "copycat";
network.networkmanager.enable = true;
time.timeZone = "Pacific/Auckland";
users.users.twe = {
	isNormalUser = true;
	extraGroups = [ "networkmanager" "wheel" ];
};
system.stateVersion = "23.11";
