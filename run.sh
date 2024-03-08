#!/bin/bash
#@niceguy

if [[ `whoami` == "root" ]]; then
	echo "We good to go..."
else
	echo "Must be run as root"
	exit 1
fi
read -p "Press any key to continue... " -n1 -s

# if i want to account for other disk configs i will need to make this dynamic
#

curl https://raw.githubusercontent.com/dolevep/nixos/main/disko_btrfs.nix -o /tmp/disko.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

nixos-generate-config --no-filesystems --root /mnt

cd /mnt/etc/nixos

echo "#WARNING: DO NOT TOUCH ./_origin-version.nix UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING" > _origin-version.nix
echo "{" >> _origin-version.nix
cat configuration.nix | grep "system.stateVersion" >> _origin-version.nix
echo "}" >> _origin-version.nix
> configuration.nix

curl https://raw.githubusercontent.com/dolevep/nixos/main/configuration.nix -o configuration.nix

cp /tmp/disko.nix /etc/nixos


