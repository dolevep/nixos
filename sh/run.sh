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
set -e

[[ ! `whoami` == "root"  ]] && echo "Must be run as root.." && exit 1

echo "Update your device (ex. '/dev/nvme0n1') in flake.nix"
read -p "Press any key to continue ..."	
curl https://raw.githubusercontent.com/dolevep/nixos/main/flake.nix -o flake.nix
vim flake.nix
echo "---"
cat flake.nix | grep "./disko.nix"
echo "---"

read -p "enter y to continue" choice
[[ ! $choice == "y" ]] && exit 1

curl https://raw.githubusercontent.com/dolevep/nixos/main/disko.nix -o /tmp/disko.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

nixos-generate-config --no-filesystems --root /mnt

pushd /mnt/etc/nixos

echo "#WARNING: DO NOT TOUCH ./_origin-version.nix UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING" > _origin-version.nix
echo "{" >> _origin-version.nix
cat configuration.nix | grep "system.stateVersion" >> _origin-version.nix
echo "}" >> _origin-version.nix
> configuration.nix

curl https://raw.githubusercontent.com/dolevep/nixos/main/configuration.nix -o configuration.nix
curl https://raw.githubusercontent.com/dolevep/nixos/main/system-configuration.nix -o system-configuration.nix
cp /tmp/disko.nix /mnt/etc/nixos/disko.nix

nixos-install --flake /mnt/etc/nixos#copycat

cp *.nix /copycat
popd +1

