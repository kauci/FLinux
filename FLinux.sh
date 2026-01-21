#!/usr/bin/env bash
set -e
PM=

echo $'\x46\x4c\x69\x6e\x75\x78\x20\xe2\x80\x94\x20\x49\x6e\x73\x74\x61\x6c\x6c\x69\x6e\x67\x20\x46\x4c\x20\x53\x74\x75\x64\x69\x6f\x20\x6f\x6e\x20\x4c\x69\x6e\x75\x78'

if command -v apt >/dev/null 2>&1
then PM=apt
else
if command -v dnf >/dev/null 2>&1
then PM=dnf
else
if command -v pacman >/dev/null 2>&1
then PM=pacman
else
echo "Unsupported Linux distro"
exit 1
fi
fi
fi

install_packages()
{
echo "Installing dependencies"
case "$PM" in
apt)
sudo apt update
sudo apt install -y wine wine64 winetricks
;;
dnf)
sudo dnf install -y wine wine-winetricks
;;
pacman)
sudo pacman -Syu --noconfirm wine winetricks
;;
esac
}

install_packages

export WINEPREFIX=$HOME/.flinux_prefix
export WINEARCH=win64

echo "Creating Wine prefix at $WINEPREFIX"
wineboot -i

echo "Installing core Windows components"
winetricks -q corefonts
winetricks -q dxvk
winetricks -q wineasio

read -p "Enter the path to the FL Studio installer (.exe): " FLPATH
if [ ! -f "$FLPATH" ]
then
echo "Installer not found"
exit 1
fi

echo "Running FL Studio installer"
wine "$FLPATH"

echo "Installation complete"
echo "To launch FL Studio:"
echo "wine $WINEPREFIX/drive_c/Program\\ Files/Image-Line/FL64.exe"
