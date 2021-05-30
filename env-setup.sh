#!/bin/bash

sudo apt-get install -y curl
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt upgrade

# Reading config file
. .env

for lib in $libs; do
    dpkg --status $lib &> /dev/null
    if [ $? -eq 0 ]; then
        echo "$lib: Already installed"
    else
        sudo apt-get install -y $lib
        echo "$lib: Succesfully installed"
    fi
done

# Installing anaconda
which conda &> /dev/null
if [ $? -eq 0 ]; then
    echo "conda: Already installed"
else
    cd /tmp
    VERSION=Anaconda3-2021.05-Linux-x86_64.sh
    curl -O https://repo.anaconda.com/archive/$VERSION
    sha256sum $VERSION
    bash $VERSION
    source ~/.bashrc
fi

# Configurind gcloud sdk
# gcloud init
