# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker script from github: 
#   https://github.com/mviereck/x11docker 
# Raw x11docker script:
#   https://raw.githubusercontent.com/mviereck/x11docker/e49e109f9e78410d242a0226e58127ec9f9d6181/x11docker
#
# Example: x11docker --desktop x11docker/lxde 
 

FROM phusion/baseimage:latest 

RUN apt-get update

# Set environment variables 
ENV DEBIAN_FRONTEND noninteractive 
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8 

# fix problems with dictionaries-common 
# See https://bugs.launchpad.net/ubuntu/+source/dictionaries-common/+bug/873551 
RUN apt-get install -y apt-utils
RUN /usr/share/debconf/fix_db.pl
RUN apt-get install -f


# The follwoing apt-get install commands will build
# a desktop environment from a simple base up to 
# some goodies, that are not essential, but useful.
# disable from last to first to make image smaller.

# lxde-core only
RUN apt-get install -y --no-install-recommends lxde-core

# lxterminal: you will need it in lxde-core to be able do do anything
RUN apt-get install -y lxterminal

# lxde text editor
RUN apt-get install -y leafpad

# lxde needs dbus-launch for whatever reason
RUN apt-get install -y dbus-x11

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y menu
RUN apt-get install -y menu-xdg
RUN apt-get install -y mime-support
RUN apt-get install -y desktop-file-utils

# icons: not needed to run lxde, but looks nicer, especially in the panel
RUN apt-get install -y hicolor-icon-theme

# look&feel settings for lxde
RUN apt-get install -y lxappearance

# xprop needed by lxde (works without it, though)
RUN apt-get install -y x11-utils

# get some goodies more than above
RUN apt-get install -y --no-install-recommends lxde

# OpenGl support in the dependencies
RUN apt-get install -y mesa-utils mesa-utils-extra


## Further:
## disabled, but maybe usefull additional installations

# enable to get xrandr and some other goodies
#RUN apt-get install -y x11-xserver-utils

# enable to get browser Chromium
#RUN apt-get install -y chromium

# enable to get full LXDE desktop environment:
# (not much missing now, though)
# (would install xorg, too, but is not needed)
#RUN apt-get install -y lxde

# clean cache to make image a bit smaller
RUN apt-get clean


# create startscript 
RUN echo '#! /bin/bash                  \n\
x-session-manager                       \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
