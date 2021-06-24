#!/bin/bash

# bootstrap.sh 3.6.3 1.15.2


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
 
mkdir -p ${HOME}/singularity
mkdir -p ${HOME}/arc/singularity
cd ${HOME}/singularity
rm -rf ${SINGULARITY_VERSION}
wget https://github.com/sylabs/singularity/archive/refs/tags/v${SINGULARITY_VERSION}.tar.gz
mv v${SINGULARITY_VERSION}.tar.gz ${HOME}/arc/singularity/singularity-${SINGULARITY_VERSION}.tar.gz
tar -xzf ${HOME}/arc/singularity/singularity-${SINGULARITY_VERSION}.tar.gz
mv singularity-${SINGULARITY_VERSION} ${SINGULARITY_VERSION}
cd ${SINGULARITY_VERSION}
echo "$SINGULARITY_VERSION" > VERSION
./mconfig -V ${SINGULARITY_VERSION}
make -C builddir
sudo make -C builddir install
 

sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
