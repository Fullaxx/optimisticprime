# ------------------------------------------------------------------------------
# Pull base image
FROM centos:7.4.1708
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

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
# RUN yum -y update --setopt=tsflags=nodocs --disableplugin=fastestmirror

# ------------------------------------------------------------------------------
# Install BASE Packages and clean up
RUN yum -y install --setopt=tsflags=nodocs --disableplugin=fastestmirror \
centos-release-scl centos-release-scl-rh epel-release \
https://centos7.iuscommunity.org/ius-release.rpm \
bash bash-completion chrony dhclient dos2unix file java-1.8.0-openjdk-devel \
less nano net-tools nmap nmap-ncat openssh-server openssh-clients passwd psmisc \
screen sudo tar tigervnc-server tree unzip vim which xterm xauth xhost zip \
apr apr-util autoconf automake bison byacc cscope cmake ctags diffstat doxygen \
elfutils emacs flex gcc gcc-c++ gcc-gfortran gdb git libtool make man-db man-pages \
ncurses-term patch patchutils rsync subversion wireshark-gnome && yum clean all && \
rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

# ------------------------------------------------------------------------------
# Not Yet
# RUN yum -y update --setopt=tsflags=nodocs --disableplugin=fastestmirror

# ------------------------------------------------------------------------------
# Install EPEL Packages and clean up
RUN yum -y install --setopt=tsflags=nodocs --disableplugin=fastestmirror \
bluefish cgdb geany most openbox terminator && yum clean all && \
rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

# ------------------------------------------------------------------------------
# Configure system
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
echo "NETWORKING=yes" > /etc/sysconfig/network && \
sed -i '/Defaults    requiretty/c\#Defaults    requiretty' /etc/sudoers

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 22
