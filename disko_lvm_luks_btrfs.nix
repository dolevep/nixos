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
							name = "copycat";
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
					root = {
						size = "100%FREE";
						content = {
							type = "filesystem";
							format = "xfs";
							mountpoint = "/";
							mountOptions = [
								"defaults"
							];
						};
					};
				};
			};
		};
	};
}
  #   disk.main = {
  #     inherit device;
  #     type = "disk";
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #         boot = {
  #           name = "boot";
  #           size = "1M";
  #           type = "EF02";
  #         };
  #         esp = {
  #           name = "ESP";
  #           size = "500M";
  #           type = "EF00";
  #           content = {
  #             type = "filesystem";
  #             format = "vfat";
  #             mountpoint = "/boot";
  #           };
  #         };
  #         swap = {
  #           size = "4G";
  #           content = {
  #             type = "swap";
  #             resumeDevice = true;
  #           };
  #         };
  #         root = {
  #           name = "root";
  #           size = "100%";
  #           content = {
  #             type = "lvm_pv";
  #             vg = "root_vg";
  #           };
  #         };
  #       };
  #     };
  #   };
  #   lvm_vg = {
  #     root_vg = {
  #       type = "lvm_vg";
  #       lvs = {
  #         root = {
  #           size = "100%FREE";
  #           content = {
  #             type = "btrfs";
  #             extraArgs = ["-f"];
  #
  #             subvolumes = {
  #               "/root" = {
  #                 mountpoint = "/";
  #               };
  #
  #               "/persist" = {
  #                 mountOptions = ["subvol=persist" "noatime"];
  #                 mountpoint = "/persist";
  #               };
  #
  #               "/nix" = {
  #                 mountOptions = ["subvol=nix" "noatime"];
  #                 mountpoint = "/nix";
  #               };
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

