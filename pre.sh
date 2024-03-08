#!/bin/bash

echo "we pregame"

# if i want to account for other disk configs i will need to make this dynamic
#

curl https://raw.githubusercontent.com/dolevep/nixos/main/disko_btrfs.nix -o /tmp/disko.nix

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

