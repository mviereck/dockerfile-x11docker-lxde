# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker and x11docker-gui from github: 
#   https://github.com/mviereck/x11docker 
#
# Example: x11docker --desktop x11docker/lxde 
#
# ToDo: Find solution for error message window on startup -> problem with LXDE policy kit not working in docker
 
#FROM phusion/baseimage:latest
FROM ubuntu:xenial

RUN apt-get update

# Set environment variables 
ENV DEBIAN_FRONTEND noninteractive 
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8 
RUN locale-gen en_US.UTF-8

# fix problems with dictionaries-common 
# See https://bugs.launchpad.net/ubuntu/+source/dictionaries-common/+bug/873551 
RUN apt-get install -y apt-utils
RUN /usr/share/debconf/fix_db.pl
RUN apt-get install -y -f

# dbus-launch needed by LXDE
RUN apt-get install -y dbus-x11

# Folder must be created by root
RUN mkdir /tmp/.ICE-unix && chmod 1777 /tmp/.ICE-unix

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y menu
RUN apt-get install -y menu-xdg
RUN apt-get install -y mime-support
RUN apt-get install -y desktop-file-utils

# xterm as an everywhere working terminal
RUN apt-get install -y --no-install-recommends xterm

# pstree, killall etc.
RUN apt-get install -y psmisc


# install core LXDE
RUN apt-get install -y --no-install-recommends lxde-core
RUN apt-get install -y --no-install-recommends lxsession
RUN apt-get install -y --no-install-recommends lxde-common
RUN apt-get install -y lxde-icon-theme

# some useful apps und icons. 
RUN apt-get install -y --no-install-recommends lxappearance leafpad

# lxsession-logout is missing. bug in Ubuntu-LXDE? Fake!
RUN echo "killall -s SIGINT lxsession" > /usr/bin/lxsession-logout
RUN chmod +x /usr/bin/lxsession-logout



## Further:
## Usefull additional installations, enable them if you like to

#sudo
RUN apt-get install -y sudo

## some X libs, f.e. allowing videos in Xephyr, avoiding xprop vala error message
#RUN apt-get install -y --no-install-recommends x11-utils

## OpenGl support in dependencies
#RUN apt-get install -y mesa-utils mesa-utils-extra

## Pulseaudio support
#RUN apt-get install -y --no-install-recommends pulseaudio

## Xrandr and some other goodies
#RUN apt-get install -y x11-xserver-utils



# clean cache to make image a bit smaller
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# pcmanfm config to get nice wallpaper
RUN mkdir -p /etc/skel/.config/pcmanfm/LXDE
RUN echo '[*]\n\
wallpaper_mode=stretch\n\
wallpaper_common=1\n\
wallpaper=/usr/share/lxde/wallpapers/lxde_blue.jpg\n\
show_documents=1\n\
show_trash=1\n\
show_mounts=1\n\
' > /etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf

RUN cp -R /etc/skel/. /root/

# create startscript 
RUN echo '#! /bin/bash\n\
if [ ! -e "$HOME/.config" ] ; then\n\
  cp -R /etc/skel/. $HOME/ \n\
  cp -R /etc/skel/* $HOME/ \n\
fi\n\
case $DISPLAY in\n\
  "")  echo "Need X server to start LXDE.\n\
  To run GUI applications in docker, you can use x11docker.\n\
  Get x11docker from github: https://github.com/mviereck/x11docker\n\
  Run image with command:\n\
    x11docker --desktop x11docker/lxde"\n\
  exit 1 ;;\n\
esac\n\
lxsession\n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
