#! /bin/bash

mkdir -p ~/SourceBuilds
cd ~/SourceBuilds
git clone https://github.com/nwg-piotr/azote.git
cd azote
sudo python3 setup.py install
