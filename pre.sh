#!/bin/bash

echo "we pregame"

curl https://raw.githubusercontent.com/vimjoyer/impermanent-setup/main/final/disko.nix -o /tmp/disko.nix

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix

