#!/bin/bash

# bootstrap.sh 3.10.2 1.19


sudo apt-get -y update
sudo apt-get -y install build-essential \
                        libssl-dev \
                        uuid-dev \
                        libgpgme11-dev \
                        squashfs-tools \
                        libseccomp-dev \
                        wget \
                        pkg-config \
                        git \
                        vim
 

export SINGULARITY_VERSION=$1
export GO_VERSION=$2


mkdir -p ${HOME}/arc/go
wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
mv go${GO_VERSION}.linux-amd64.tar.gz ${HOME}/arc/go/
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf ${HOME}/arc/go/go${GO_VERSION}.linux-amd64.tar.gz
export PATH=${PATH}:/usr/local/go/bin
echo "export PATH=\${PATH}:/usr/local/go/bin" >> .bashrc
rm -rf ${HOME}/arc/go

mkdir -p ${HOME}/singularity
cd ${HOME}/singularity
rm -rf ${SINGULARITY_VERSION}
git clone --recurse-submodules https://github.com/sylabs/singularity.git
mv singularity ${SINGULARITY_VERSION}
cd ${SINGULARITY_VERSION}
git checkout --recurse-submodules v${SINGULARITY_VERSION}
echo "${SINGULARITY_VERSION}" > VERSION
./mconfig -V ${SINGULARITY_VERSION}
make -C builddir
sudo make -C builddir install
 

sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade


cd ${HOME}
git clone https://github.com/mbareford/container-factory.git
mv container-factory work
