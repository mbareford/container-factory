#!/bin/bash


echo "deb http://us.archive.ubuntu.com/ubuntu \
      focal main universe restricted multiverse" > /etc/apt/sources.list

apt-get -y update

apt-get -y install build-essential \
                   uuid-dev \
                   libssl-dev \
                   libseccomp-dev \
                   libgpgme11-dev \
		   zlib1g-dev \
                   iputils-ping \
                   squashfs-tools \
		   m4 \
                   lzip \
                   liblz4-1 \
                   wget \
                   curl \
                   git \
                   subversion \
                   perl \
                   liburi-perl \
                   pkg-config \
                   vim \
                   bc \
                   autoconf \
                   autogen \
                   libtool \
		   environment-modules

apt-get -y upgrade
apt-get -y dist-upgrade

apt-get -y autoremove



apt-get -y update

if [ ! -z "${1}" ]; then
  # install gcc compilers
  GNU_VERSION=${1}
  apt-get -y install gcc-${GNU_VERSION} g++-${GNU_VERSION} gfortran-${GNU_VERSION}

  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GNU_VERSION} ${GNU_VERSION}
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${GNU_VERSION} ${GNU_VERSION}
  update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-${GNU_VERSION} ${GNU_VERSION}

  update-alternatives --set gcc /usr/bin/gcc-${GNU_VERSION}
  update-alternatives --set g++ /usr/bin/g++-${GNU_VERSION}
  update-alternatives --set gfortran /usr/bin/gfortran-${GNU_VERSION}
fi

# install support for various interconnects (IB, Intel omni-path)
# and comms libraries (UCX, PMI)
apt-get -y install libibverbs-dev \
                   opa-fm \
                   opa-fastfabric \
                   libpsm2-2 \
                   libpsm2-2-compat \
                   libpsm2-dev \
                   libpmix-dev \
		   libnuma-dev

apt-get -y upgrade
apt-get -y dist-upgrade

apt-get -y autoremove
