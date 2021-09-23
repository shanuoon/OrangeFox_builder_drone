#!/bin/bash

MANIFEST="https://gitlab.com/OrangeFox/sync.git"
DEVICE=RMX3171
DT_LINK="https://github.com/mastersenpai0405/android_recovery_realme_RMX3171 -b android-10.0"
DT_PATH=device/realme/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y

echo " ===+++ Sync OrangeFox +++==="
git clone $MANIFEST ~/FOX && cd ~/FOX
./get_fox_10.sh ~/fox_10.0
cd ~/fox_10.0
git clone $DT_LINK $DT_PATH
rm -rf ~/fox_10.0/.git
git clone https://github.com/senpaimaster05/orangefox_vendorsetup.sh ~/fox_10.0/$DT_PATH

echo " ====+++ Building OrangeFox +++==="
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"
lunch omni_${DEVICE}-eng && mka recoveryimage

# Upload zips & recovery.img
echo " ===+++ Uploading Recovery +++===
cd out/target/product/$DEVICE

curl -sL https://git.io/file-transfer | sh
./transfer wet *.zip
