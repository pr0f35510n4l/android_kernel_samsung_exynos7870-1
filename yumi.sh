#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=~/Android/Toolchains/gcc-linaro-7.5.0/bin/aarch64-linux-gnu-
export ANDROID_MAJOR_VERSION=q
export ANDROID_PLATFORM_VERSION=10

for device in $*; do
  make clean && make mrproper ;
  rm -rf out ;
  make O=./Yumi/Out $device ;
  make O=./Yumi/Out -j64 ;
  sudo cp -r ./Yumi/Q/ramdisk ./Yumi/AIK/ramdisk ;
  cp -r ./Yumi/Q/split_img ./Yumi/AIK/split_img ;
  mv ./Yumi/Out/arch/arm64/boot/Image ./Yumi/AIK/split_img/boot.img-zImage ;
  mv ./Yumi/Out/arch/arm64/boot/dtb.img ./Yumi/AIK/split_img/boot.img-dt ;
  sudo -S ./Yumi/AIK/repackimg.sh ;
  mkdir ./Yumi/Product
  mv ./Yumi/AIK/image-new.img ./Yumi/Product/YumiKernel_V1.0-"$*".img ;
  ./Yumi/AIK/cleanup.sh ;
done
