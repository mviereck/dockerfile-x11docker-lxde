# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop x11docker/lxde
#           x11docker x11docker/lxde pcmanfm

FROM debian:stretch

RUN apt-get   update
RUN apt-get install -y apt-utils
RUN apt-get install -y dbus-x11 x11-utils x11-xserver-utils
RUN apt-get install -y procps psmisc

# OpenGL support
RUN apt-get install -y libxv1 mesa-utils mesa-utils-extra libgl1-mesa-glx libglew2.0 \
                       libglu1-mesa libgl1-mesa-dri libdrm2 libgles2-mesa libegl1-mesa

# Language/locale settings
ENV LANG=en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN apt-get install -y locales

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs
RUN apt-get install -y menu menu-xdg mime-support desktop-file-utils desktop-base

# LXDE
RUN apt-get install -y --no-install-recommends lxde

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

# GTK 2 settings for icons and style
RUN echo '\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.gtkrc-2.0

# GTK 3 settings for icons and style
RUN mkdir -p /etc/skel/.config/gtk-3.0
RUN echo '\n\
[Settings]\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.config/gtk-3.0/settings.ini


# create startscript 
RUN echo '#! /bin/bash\n\
[ -e "$HOME/.config" ] || cp -R /etc/skel/. $HOME/ \n\
openbox --sm-disable &\n\
pcmanfm --desktop &\n\
lxpanel \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start

