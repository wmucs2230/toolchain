#!/bin/bash

CURDIR=$(pwd)

# install dependencies
echo -e "\e[32m>> Update packages...\e[39m"
sudo apt update
echo -e "\e[32m>> Install dependencies...\e[39m"
sudo apt install -y binutils-msp430 build-essential curl gcc-msp430 gdb-msp430 git libboost1.71-all-dev libhidapi-dev libusb-1.0-0-dev libusb-dev libreadline-dev minicom msp430-libc msp430mcu vim wget

# install udev rules and add user to dialout group
echo -e "\e[32m>> Install udev rules and add user to dialout...\e[39m"
chmod +x msp430uif_install.sh
sudo ./msp430uif_install.sh --install
sudo usermod -a -G dialout $(whoami)

# install libmsp430.so from source
# echo -e "\e[32m>> Build libmsp430.so library from source...\e[39m"
echo -e "\e[32m>> Copy libmsp430.so library into /usr/lib...\e[39m"
# mkdir libmsp430
# cd libmsp430
# unzip -q ../slac460y.zip
# patch -p1 < ../libmsp430.patch
# make
# echo -e "\e[32m>> Install libmsp430.so...\e[39m"
sudo mv libmsp430.so /usr/lib
sudo ldconfig
cd $CURDIR

# install mspdebug custom fork
echo -e "\e[32m>> Build mspdebug from source...\e[39m"
git clone https://github.com/wmucs2230/mspdebug.git
cd mspdebug
make
echo -e "\e[32m>> Install mspdebug...\e[39m"
sudo make install
cd $CURDIR

# install libemb custom fork
echo -e "\e[32m>> Build libemb from source...\e[39m"
git clone https://github.com/wmucs2230/libemb.git
cd libemb
TARCH=MSP430 make
echo -e "\e[32m>> Install libemb...\e[39m"
TARCH=MSP430 INSTDIR=/usr/msp430 sudo -E make install
cd $CURDIR

# create ~/msp430 for code and drop in test program
echo -e "\e[32m>> Create ~/msp430 directory with example files...\e[39m"
mkdir -p /home/$(whoami)/msp430
cp hworld.c /home/$(whoami)/msp430/
cp Makefile /home/$(whoami)/msp430/

# set minicom defaults
echo -e "\e[32m>> Set defaults for minicom...\e[39m"
sudo cp minirc.dfl /etc/minicom

# all done, mention restarting
echo -e "\e[32m>> Installation complete! You should probably restart your machine\e[39m"

