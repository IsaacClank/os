#!/bin/bash

if [ "$EUID" != "0" ]; then
	echo "Please run script as root"
	exit 1
fi

# backup mirrorlist
cp -f /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# run reflector
exec reflector --verbose --sort rate \
	--age 24 --score 8 --protocol https \
	--country CN,HK,TW \
	--save /etc/pacman.d/mirrorlist
