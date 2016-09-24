# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker and x11docker-gui from github: 
#   https://github.com/mviereck/x11docker 
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
RUN apt-get install -y -f

RUN apt-get install -y --no-install-recommends lxde

# lxsession-logout is missing. bug in LXDE?
RUN echo "killall -s SIGINT lxsession" > /usr/bin/lxsession-logout
RUN chmod +x /usr/bin/lxsession-logout

# some useful x apps. 
RUN apt-get install -y x11-utils

## Further:
## disabled, but maybe usefull additional installations

# enable to get xrandr and some other goodies
#RUN apt-get install -y x11-xserver-utils

# OpenGl support in the dependencies
RUN apt-get install -y mesa-utils mesa-utils-extra

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y menu
RUN apt-get install -y menu-xdg
RUN apt-get install -y mime-support
RUN apt-get install -y desktop-file-utils

# clean cache to make image a bit smaller
RUN apt-get clean


# create startscript 
RUN echo '#! /bin/bash                  \n\
lxsession                       \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
