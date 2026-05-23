#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install gdb emacs vim git zsh gdb-multiarch \
    python3 python3-pip python3-dev python3-setuptools python-is-python3 \
    libssl-dev libffi-dev build-essential \
    gdbserver libelf-dev pax-utils python3-pkg-resources \
    linux-headers-$(uname -r)

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get -y install libc6-dev-i386

# Enable ptrace
echo "kernel.yama.ptrace_scope=0" | sudo tee -a /etc/sysctl.conf
# reload sysctl
sudo sysctl --system

# Installing tools
python3 -m pip install --break-system-packages -U setuptools
python3 -m pip install --break-system-packages pwntools
python3 -m pip install --break-system-packages ROPGadget
python3 -m pip install --break-system-packages ropper
python3 -m pip install --break-system-packages pycryptodome

sudo timedatectl set-timezone 'EST'

sudo apt-get install sshpass
# sudo mv /home/vagrant/seclab /bin/seclab
# sudo chmod +x /bin/seclab

# pwndbg
cd /home/kali
git clone https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh
echo "source $PWD/gdbinit.py" > /home/kali/.gdbinit

# Installing kflag module
cd /home/kali/ctf/tut/kflag
sudo make clean
sudo make all
sudo make insmod
sudo mv ./seclab /etc/init.d/seclab
sudo chmod +x /etc/init.d/seclab
sudo chown root:root /etc/init.d/seclab
sudo ln -f -s /etc/init.d/seclab /etc/rc2.d/S50seclab
sudo systemctl daemon-reload
sudo service seclab start

# deploying tutorials
mkdir -p /home/ctf
sudo rsync -a /home/kali/src/tut/ /home/ctf
sudo chown -R kali: /home/ctf/tuts/lab*
sudo cp -f /home/ctf/seclab /bin/

