FROM ubuntu:16.04
MAINTAINER hassiweb <nryk.hashimoto@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
#RUN apt-get -yq dist-upgrade

############################################
# build_helper
############################################

# check_install_oai_software()
## Ubuntu specific common software package
#RUN apt-get install -yq software-properties-common

## Ubuntu 16.04 specific packages
RUN apt-get install -yq libtasn1-6-dev libgnutls28-dev libatlas-dev iproute libconfig8-dev

## Dependencies for OpenAirInterface software
RUN apt-get -yq install \
    autoconf  \
    automake  \
    bison  \
    build-essential \
    cmake \
    cmake-curses-gui  \
    doxygen \
    doxygen-gui \
    texlive-latex-base \
    ethtool \
    flex  \
    gdb  \
    git \
    graphviz \
    gtkwave \
    guile-2.0-dev  \
    iperf \
    iptables \
    iptables-dev \
    libatlas-base-dev \
    libblas-dev \
    liblapack-dev\
    liblapacke-dev\
    libffi-dev \
    libforms-bin \
    libforms-dev \
    libgcrypt11-dev \
    libgmp-dev \
    libgtk-3-dev \
    libidn2-0-dev  \
    libidn11-dev \
    libmysqlclient-dev  \
    libpython2.7-dev \
    libsctp1  \
    libsctp-dev  \
    libssl-dev  \
    libtool  \
    libusb-1.0-0-dev \
    libxml2 \
    libxml2-dev  \
    libxslt1-dev \
    mscgen  \
    octave-signal \
    openssh-client \
    openssh-server \
    openssl \
    python  \
    subversion \
    xmlstarlet \
    python-pip \
    pydb \
    libyaml-dev \
    wget \
    libxpm-dev \
    libboost-all-dev

RUN apt-get install -qy nettle-dev nettle-bin

## ASN1 compiler with Eurecom fixes
WORKDIR /root
RUN git clone https://gitlab.eurecom.fr/oai/asn1c.git
RUN cd asn1c && \
    git checkout 0a7524184f16e7093990a31d8d4db487a16e5782 && \
    autoreconf -iv && \
    ./configure && \
    make -j`nproc` && \
    make install

# install_usrp_uhd_driver_from_source()
## Dependencies for the UHD driver for the USRP hardware
# RUN apt-get -yq install autoconf build-essential libusb-1.0-0-dev cmake wget pkg-config libboost-all-dev python-dev python-cheetah git subversion python-software-properties

## Dependencies for UHD image downloader script
# RUN apt-get -yq install python-mako python-requests

## Fetching the uhd 3.010.001 driver for our USRP SDR card
# RUN wget http://files.ettus.com/binaries/uhd/uhd_003.010.001.001-release/uhd-3.10.1.1.tar.gz && tar xvzf uhd-3.10.1.1.tar.gz && cd UHD_3.10.1.1_release && mkdir build && cd build && cmake ../ && make && make install && ldconfig && python /usr/local/lib/uhd/utils/uhd_images_downloader.py

# install_protobuf_from_source()
RUN cd /tmp && \
    wget https://github.com/google/protobuf/releases/download/v3.3.0/protobuf-cpp-3.3.0.tar.gz && \
    tar -xzvf protobuf-cpp-3.3.0.tar.gz && \
    cd protobuf-3.3.0/ && \
    ./configure && \
    make -j`nproc` && \
    make install && \
    ldconfig

# install_protobuf_c_from_source()
RUN cd /tmp && \
    git clone https://github.com/protobuf-c/protobuf-c.git && \
    cd protobuf-c && \
    git checkout 2a46af42784abf86804d536f6e0122d47cfeea45 && \
    ./autogen.sh && \
    ./configure && \
    make -j`nproc` && \
    make install && \
    ldconfig

# check_install_additional_tools
# RUN apt-get install -qy         check \
#         dialog \
#         dkms \
#         gawk \
#         libboost-all-dev \
#         libpthread-stubs0-dev \
#         openvpn \
#         pkg-config \
#         python-dev  \
#         python-pexpect \
#         sshfs \
#         swig  \
#         tshark \
#         uml-utilities \
#         unzip  \
#         valgrind  \
#         vlan      \
#         ctags \
#         ntpdate
# RUN apt-get -qy install libffi-dev libxslt1-dev
# RUN pip install --upgrade pip
# RUN pip install paramiko==1.17.1
# RUN pip install pyroute2
# RUN update-alternatives --set liblapack.so /usr/lib/atlas-base/atlas/liblapack.so

############################################
# OAI repository
############################################
RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git && \
    cd openairinterface5g && \
    git checkout v1.0.3


############################################
# LimeSDR specific packages
############################################

# Install the required Ubuntu packages for Lime
RUN apt-get install -yq software-properties-common && \
    add-apt-repository -y ppa:myriadrf/drivers && \
    apt-get update -y && \
    apt-get install -yq limesuite liblimesuite-dev limesuite-udev limesuite-images && \
    apt-get install -yq soapysdr-tools soapysdr-module-lms7

#RUN apt-get install -yq cmake g++ libpython-dev python-numpy swig git libsqlite3-dev libi2c-dev libusb-1.0-0-dev libwxgtk3.0-dev freeglut3-dev && \  
#    cd /tmp && \
#    git clone https://github.com/pothosware/SoapySDR.git && \
#    cd SoapySDR && \
#    git pull origin master && \
#    mkdir build && cd build && \
#    cmake .. && \
#    make -j4 && \
#    make install && \
#    ldconfig

#RUN cd /tmp && \
#    git clone https://github.com/myriadrf/LimeSuite.git && \
#    cd LimeSuite && \
#    mkdir -p build && cd build && \
#    cmake .. && \
#    make -j4 && \
#    make install && \
#    ldconfig

#RUN cd /tmp/LimeSuite/udev-rules/ && \
#    ./install.sh
# Download board firmware
#sudo LimeUtil --update

# Fetch configurations for LimeSDR
WORKDIR /root/
RUN git clone https://github.com/myriadrf/trx-lms7002m

###################################
# build_oai
###################################

# LTE softmodem compilation
WORKDIR /root/openairinterface5g
RUN cd cmake_targets && mkdir -p lte_build_oai/build
WORKDIR /root/openairinterface5g/cmake_targets/lte_build_oai

## CmakeLists generation
RUN echo "cmake_minimum_required(VERSION 2.8)"                    > CMakeLists.txt  && \
    echo "set ( CMAKE_BUILD_TYPE \"\" )"                          >> CMakeLists.txt && \
    echo "set ( CFLAGS_PROCESSOR_USER \"\" )"                     >> CMakeLists.txt && \
    echo "set ( UE_EXPANSION \"False\" )"                         >> CMakeLists.txt && \
    echo "set ( PRE_SCD_THREAD \"False\" )"                       >> CMakeLists.txt && \
    echo "set ( UESIM_EXPANSION \"False\" )"                      >> CMakeLists.txt && \
    echo "set ( RRC_ASN1_VERSION \"Rel14\")"                      >> CMakeLists.txt && \
    echo "set ( ENABLE_VCD_FIFO \"False\")"                       >> CMakeLists.txt && \
    echo "set ( RF_BOARD \"OAI_LMSSDR\")"                         >> CMakeLists.txt && \
    echo "set ( TRANSP_PRO \"None\")"                             >> CMakeLists.txt && \
    echo "set (PACKAGE_NAME \"lte-softmodem\")"                   >> CMakeLists.txt && \
    echo "set (DEADLINE_SCHEDULER \"False\" )"                    >> CMakeLists.txt && \
    echo "set (CPU_AFFINITY \"False\" )"                          >> CMakeLists.txt && \
    echo "set ( T_TRACER \"False\" )"                             >> CMakeLists.txt && \
    echo "set (UE_AUTOTEST_TRACE \"False\")"                      >> CMakeLists.txt && \
    echo "set (UE_DEBUG_TRACE \"False\")"                         >> CMakeLists.txt && \
    echo "set (UE_TIMING_TRACE \"False\")"                        >> CMakeLists.txt && \
    echo "set (USRP_REC_PLAY $USRP_REC_PLAY)"                     >> CMakeLists.txt && \
    echo 'include(${CMAKE_CURRENT_SOURCE_DIR}/../CMakeLists.txt)' >> CMakeLists.txt

## Compilation
WORKDIR /root/openairinterface5g/cmake_targets/lte_build_oai/build
RUN OPENAIR_HOME=/root/openairinterface5g OPENAIR_DIR=$OPENAIR_HOME OPENAIR1_DIR=$OPENAIR_HOME/openair1 OPENAIR2_DIR=$OPENAIR_HOME/openair2 OPENAIR3_DIR=$OPENAIR_HOME/openair3 OPENAIR_TARGETS=$OPENAIR_HOME/targets cmake ../ && \
    make -j`nproc` lte-softmodem && \
    make -j`nproc` params_libconfig && \
    make -j`nproc` coding

## Compilation of lmssdr driver
RUN make -j`nproc` oai_lmssdrdevif && \
    ln -sf liboai_lmssdrdevif.so liboai_device.so

###################################
# Command definition
###################################

# Run directly the eNodeB code
ENTRYPOINT ["/root/openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem"]
CMD ["-O", "/config/enb.band1.tm1.25PRB.lmssdr.conf", "--rf-config-file", "/root/trx-lms7002m/config-limeSDR/LimeSDR_Mini_above_1p8GHz.ini"]
