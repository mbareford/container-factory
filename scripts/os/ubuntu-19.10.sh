#!/bin/bash


echo "deb http://us.archive.ubuntu.com/ubuntu \
      eoan main universe restricted multiverse" > /etc/apt/sources.list

apt-get -y update
apt-get -y install build-essential \
                   uuid-dev \
                   libssl-dev \
                   libseccomp-dev \
                   libgpgme11-dev \
                   iputils-ping \
                   squashfs-tools \
		   lzip \
		   liblz4-1 \
                   wget \
		   curl \
                   git \
                   subversion \
		   perl \
		   liburi-perl \
                   pkg-config \
                   m4 \
                   gfortran \
                   zlib1g-dev \
                   vim \
                   bc \
		   autoconf \
                   autogen \
                   environment-modules \
                   libtool \
                   libibverbs-dev


# install gnu compilers for a range of versions
apt-get -y install gcc-7 g++-7 gfortran-7
apt-get -y install gcc-8 g++-8 gfortran-8
apt-get -y install gcc-9 g++-9 gfortran-9

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 7
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 7
update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-7 7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8
update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-8 8
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9
update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-9 9

GNU_VERSION=$1
update-alternatives --set gcc /usr/bin/gcc-${GNU_VERSION}
update-alternatives --set g++ /usr/bin/g++-${GNU_VERSION}
update-alternatives --set gfortran /usr/bin/gfortran-${GNU_VERSION}


apt-get -y upgrade
apt-get -y dist-upgrade


# install support for intel omni-path comms architecture
# install pmi libraries
apt-get -y update
apt-get -y install opa-fm \
                   opa-fastfabric \
                   libpsm2-2 \
                   libpsm2-2-compat \
                   libpsm2-dev \
		   libpmix-dev

apt-get -y upgrade
apt-get -y dist-upgrade


# remove non-existent drivers
rm -f /etc/libibverbs.d/cxgb3.driver
rm -f /etc/libibverbs.d/cxgb4.driver
rm -f /etc/libibverbs.d/ipathverbs.driver
rm -f /etc/libibverbs.d/mthca.driver
rm -f /etc/libibverbs.d/nes.driver
