# ------------------------------------------------------------------------------
# Pull base image
FROM centos:7.4.1708
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV BOOSTURL 'https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.61.0%2Fboost_1_61_0.tar.bz2%2Fdownload%3Fuse_mirror%3Dsuperb-dca2&ts=1555350381&use_mirror=superb-dca2'
ENV AMQCPPURL 'http://archive.apache.org/dist/activemq/activemq-cpp/3.9.3/activemq-cpp-library-3.9.3-src.tar.bz2'

# ------------------------------------------------------------------------------
# Thanks to https://github.com/jdeathe/centos-ssh
# Thanks to https://github.com/gluster/gluster-containers
# ------------------------------------------------------------------------------
# Install keys and Update rpmdb
RUN rpm --rebuilddb && \
rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 && \
rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && \
rpm --import https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY

# ------------------------------------------------------------------------------
# Not Yet
# RUN yum -y update --disableplugin=fastestmirror

# ------------------------------------------------------------------------------
# Install BASE Packages and clean up
RUN yum -y install --disableplugin=fastestmirror \
centos-release-scl centos-release-scl-rh epel-release \
https://centos7.iuscommunity.org/ius-release.rpm \
bash bash-completion bzip2 chrony dhclient dos2unix file libmicrohttpd less \
nano net-tools nmap nmap-ncat openssh-server openssh-clients passwd psmisc \
maven java-1.8.0-openjdk-devel Cython numpy python-setuptools python-virtualenv \
screen sudo tar tcpdump tigervnc-server tree unzip vim which xterm xauth xhost zip \
apr apr-util autoconf automake bison byacc cscope cmake ctags diffstat doxygen \
elfutils emacs flex gcc gcc-c++ gcc-gfortran gdb git libtool make man-db man-pages \
ncurses-term patch patchutils rsync subversion wireshark-gnome && yum clean all && \
rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

# ------------------------------------------------------------------------------
# Not Yet
# RUN yum -y update --disableplugin=fastestmirror

# ------------------------------------------------------------------------------
# Install EPEL Packages and clean up
RUN yum -y install --disableplugin=fastestmirror \
bluefish cgdb geany htop nedit most openbox python2-pip scons terminator zeromq && \
yum clean all && rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

# ------------------------------------------------------------------------------
# Things to think about
# chromium(epel)

# ------------------------------------------------------------------------------
# Install some dev packages
RUN yum -y install apr-devel bzip2-devel fftw-devel \
libpcap-devel libcurl-devel openssl-devel zeromq-devel && \
yum clean all && rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

# ------------------------------------------------------------------------------
# Install boost
RUN wget "${BOOSTURL}" -O /tmp/boost.tar.bz2 && \
tar xf /tmp/boost.tar.bz2 -C / && cd /boost_*/ && \
./bootstrap.sh --prefix=/usr --libdir=/usr/lib64 && \
./b2 install --with=all -j `nproc` && \
cd / && rm -rf /tmp/*.tar.bz2 /boost_*

# ------------------------------------------------------------------------------
# Install activemq-cpp
RUN wget "${AMQCPPURL}" -O /tmp/activemq.tar.bz2 && \
tar xf /tmp/activemq.tar.bz2 -C / && cd /activemq-cpp-library-* && \
./configure --prefix=/usr --libdir=/usr/lib64 --disable-ssl && \
make -j `nproc` && make install && \
cd / && rm -rf /tmp/*.tar.bz2 /activemq-cpp-library-*

# ------------------------------------------------------------------------------
# Configure system
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
echo "NETWORKING=yes" > /etc/sysconfig/network && \
sed -i '/Defaults    requiretty/c\#Defaults    requiretty' /etc/sudoers

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 22
EXPOSE 5901
