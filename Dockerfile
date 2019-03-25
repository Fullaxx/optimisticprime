# ------------------------------------------------------------------------------
# Pull base image
FROM centos:7.4.1708
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Thanks to https://github.com/jdeathe/centos-ssh
# ------------------------------------------------------------------------------
# Install keys and Update rpmdb
RUN rpm --rebuilddb && \
rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 && \
rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && \
rpm --import https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY

# ------------------------------------------------------------------------------
# Install Packages and clean up
RUN yum -y install --setopt=tsflags=nodocs --disableplugin=fastestmirror \
centos-release-scl centos-release-scl-rh epel-release \
https://centos7.iuscommunity.org/ius-release.rpm \
apr apr-util bash chrony net-tools openssh-server openssh-clients passwd sudo \
tar file psmisc less zip unzip tree dos2unix screen nano which dhclient vim emacs \
autoconf automake bash-completion bison byacc cscope cmake ctags diffstat doxygen elfutils flex \
gcc gcc-c++ gcc-gfortran gdb git libtool make man-db man-pages \
ncurses-term patch patchutils rsync subversion tigervnc-server xterm xauth xhost && \
yum clean all && rm -rf /var/cache/yum && \
rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*
