#!/bin/bash
#@niceguy

echo "we pregame"

# if i want to account for other disk configs i will need to make this dynamic
#

curl https://raw.githubusercontent.com/dolevep/nixos/main/disko_btrfs.nix -o /tmp/disko.nix

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

sudo nixos-generate-config --no-filesystems --root /mnt

cd /etc/nixos

echo "#WARNING: DO NOT TOUCH ./_origin-version.nix UNLESS ABSOLUTELY CERTAIN YOU KNOW WHAT YOU'RE DOING" > _origin-version.nix
echo "{" >> _origin-version.nix
cat configuration.nix | grep "system.stateVersion" >> _origin-version.nix
echo "}" >> _origin-version.nix
> configuration.nix

curl https://raw.githubusercontent.com/dolevep/nixos/main/configuration.nix -o configuration.nix

sudo cp /tmp/disko.nix /etc/nixos


