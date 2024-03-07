{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}: {
  disko.devices = {
		disk.main = {
			inherit device;
			type = "disk";
			content = {
				type = "gpt";
				partitions = {
					boot = {
						name = "boot";
						size = "1024M";
						type = "EF00";
						content = {
							type = "filesystem";
							format = "vfat";
							mountpoint = "/boot";
							mountOptions = [
								"defaults"
							];
						};
					};
					luks = {
						size = "100%";
						content = {
							type = "luks";
#							name = "luks";
							settings = {
								allowDiscards = true;
							};
							content = {
								type = "lvm_pv";
								vg = "copycat";
							};
						};
					};
				};
			};
		};
		lvm_vg = {
			copycat = {
				type = "lvm_vg";
				lvs = {
					swap = {
						size = "4GiB";
						content = {
							type = "swap";
							resumeDevice = true;
						};
					};
					root = {
						size = "100%FREE";
						content = {
							type = "filesystem";
							format = "btrfs";
							extraArgs = [ "-f" ];

							subVolumes = {
								"/root" = {
									mountpoint = "/";
								};
								"/persist" = {
									mountOptions = [ "subvol=persist" "noatime" ];
									mountpoint = "/persist";
								};
								"/nix" = {
									mountOptions = [ "subvol=nix" "noatime" ];
									mountpoint = "/nix";
								};
							};
						};
					};
				};
			};
		};
	};
}
