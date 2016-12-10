# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker and x11docker-gui from github: 
#   https://github.com/mviereck/x11docker 
#
# Example: x11docker --desktop x11docker/lxde 
#
 
FROM ubuntu:xenial

RUN apt-get   update

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

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y menu
RUN apt-get install -y menu-xdg
RUN apt-get install -y mime-support
RUN apt-get install -y desktop-file-utils


# install core LXDE
RUN apt-get install -y --no-install-recommends lxde-core
RUN apt-get install -y --no-install-recommends lxde-common
RUN apt-get install -y lxde-icon-theme

# some useful lxde apps
RUN apt-get install -y --no-install-recommends lxappearance leafpad lxterminal


## Further:
## Usefull additional installations, enable or disable as you like to

# pstree etc.
RUN apt-get install -y psmisc

#sudo
RUN apt-get install -y sudo

## some X libs, f.e. allowing videos in Xephyr
#RUN apt-get install -y --no-install-recommends x11-utils

## OpenGL support in dependencies
#RUN apt-get install -y mesa-utils mesa-utils-extra

## Pulseaudio support
#RUN apt-get install -y --no-install-recommends pulseaudio

## Xrandr and some other goodies
#RUN apt-get install -y x11-xserver-utils

## lightweight dillo browser
#RUN apt-get install -y dillo



# clean cache to make image a bit smaller
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# config for lxpanel, including replacement for lxsession-logout
RUN mkdir -p /etc/skel/.config/lxpanel/default
RUN echo '[Command]\n\
Logout=pkill lxpanel\n\
FileManager=pcmanfm %s \n\
Terminal=xterm -e \n\
' > /etc/skel/.config/lxpanel/default/config

# pcmanfm config to get nice wallpaper
RUN mkdir -p /etc/skel/.config/pcmanfm/default
RUN echo '[*]\n\
wallpaper_mode=stretch\n\
wallpaper_common=1\n\
wallpaper=/usr/share/lxde/wallpapers/lxde_blue.jpg\n\
show_documents=1\n\
show_trash=1\n\
show_mounts=1\n\
' > /etc/skel/.config/pcmanfm/default/desktop-items-0.conf

# GTK 2+3 settings for icons and style
RUN mkdir -p /etc/skel/.config/gtk-3.0
RUN echo '\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.gtkrc-2.0
RUN echo '\n\
[Settings]\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.config/gtk-3.0/settings.ini

RUN cp -R /etc/skel/. /root/

# create startscript 
RUN echo '#! /bin/bash\n\
if [ ! -e "$HOME/.config" ] ; then\n\
  cp -R /etc/skel/. $HOME/ \n\
  cp -R /etc/skel/* $HOME/ \n\
fi\n\
if [ "$*" = "" ] ; then \n\
  openbox --sm-disable &\n\
  pcmanfm --desktop &\n\
  lxpanel \n\
else \n\
  eval $* \n\
fi \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
