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

echo "Enter your device name [nvme0n1]: "

read DISK_DEV

[[ $DISK_DEV == "" ]] && DISK_DEV="nvme0n1";

echo "[/dev/$DISK_DEV] ... is this correct?"
read -n1 -r -p " y? : " CHOICE
case $CHOICE in
  y|Y|"") echo "wheeee";;
  *) echo "Fuckitbruh" && exit 1 ;;
esac

curl https://raw.githubusercontent.com/dolevep/nixos/main/base/disko.nix?$RANDOM -o /tmp/disko.nix

ACTUAL_DEV='"/dev/'${DISK_DEV}'"'
echo "fuck you for now no variable on this ... its being shitty"
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/'${DISK_DEV}'"'

nixo-generate-config --no-filesystems --root /mnt
mkdir -p /copycat/base
pushd /copycat/base
mv /tmp/disko.nix .
mv /mnt/etc/nixos/* .


echo "#WARNING: DO NOT TOUCH ./_origin-version.nix UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING" > _origin-version.nix
echo "{" >> _origin-version.nix
cat configuration.nix | grep "system.stateVersion" >> _origin-version.nix
echo "}" >> _origin-version.nix
> configuration.nix

curl https://raw.githubusercontent.com/dolevep/nixos/main/base/flake.nix -o flake.nix
sed -i "s/nvme0n1/$DISK_DEV/g" flake.nix
curl https://raw.githubusercontent.com/dolevep/nixos/main/base/configuration.nix -o configuration.nix
echo "{}" > system-configuration.nix
# curl https://raw.githubusercontent.com/dolevep/nixos/main/system-configuration.nix -o system-configuration.nix

nixos-install --flake /copycat/base#default
popd +1


