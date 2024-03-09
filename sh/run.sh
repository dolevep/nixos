#!/bin/bash
# run.sh
#
# description: install nixos on a new system
# @niceguy
#
# usage:
#   remotely: sh <(curl imp.nz) 
#   locally: sh run.sh
#
# NOTES:
#   this is not very dynamic - yet, if i feel the need i'll update it to be so
#   importantly you will need to manually and preemptively handle the file names 
#   and device names currently 
#
#   ... (hey thats declaritive at least!) 
#
#
if [[ `whoami` == "root" ]]; then
	echo "We good to go..."
else
	echo "Must be run as root"
	exit 1
fi
#read -p "Press any key to continue... " -n1 -s

# if i want to account for other disk configs i will need to make this dynamic
#

curl https://raw.githubusercontent.com/dolevep/nixos/main/disko.nix -o /tmp/disko.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

nixos-generate-config --no-filesystems --root /mnt

cd /mnt/etc/nixos

echo "#WARNING: DO NOT TOUCH ./_origin-version.nix UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING" > _origin-version.nix
echo "{" >> _origin-version.nix
cat configuration.nix | grep "system.stateVersion" >> _origin-version.nix
echo "}" >> _origin-version.nix
> configuration.nix

curl https://raw.githubusercontent.com/dolevep/nixos/main/configuration.nix -o configuration.nix
curl https://raw.githubusercontent.com/dolevep/nixos/main/flake.nix -o flake.nix
cp /tmp/disko.nix /mnt/etc/nixos/disko.nix

echo "Bout to start installing..."
#read -p "Press any key to continue... " -n1 -s

nixos-install --flake /mnt/etc/nixos#copycat
cd /etc/nixos
git clone https://github.com/dolevep/nixos.git .
reboot
