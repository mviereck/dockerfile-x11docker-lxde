# x11docker/lxde
# 
# Run LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: 
#  - Run desktop:
#      x11docker --desktop x11docker/lxde
#  - Run single application:
#      x11docker x11docker/lxde pcmanfm
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Sound support with option                    --alsa
# With pulseaudio in image, sound support with --pulseaudio
#
# See x11docker --help for further options.

FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get  update

# Install dummy packages for useless dependencies to shrink down image size
RUN apt-get install -y --no-install-recommends equivs && \
echo '#! /bin/bash \n\
dummydeb() { \n\
  echo "Section: misc\n\
Standards-Version: 3.9.2\n\
Package: $1\n\
Description: dummy package to avoid installation of $1 \n\
" >$1 \n\
  equivs-build $1 \n\
  apt-get install -y ./$1_1.0_all.deb \n\
  rm $1 $1_1.0_all.deb \n\
} \n\
dummydeb lxpolkit \n\
dummydeb lightdm \n\
dummydeb light-locker \n\
dummydeb policykit-1 \n\
dummydeb adwaita-icon-theme \n\
dummydeb gnome-icon-theme \n\
' > makedummydeb.sh && bash makedummydeb.sh && \
apt-get purge -y equivs && apt-get -y autoremove


# LXDE
RUN apt-get install -y --no-install-recommends lxde

# Additional tools. kmod and xz-utils for nvidia driver install support.
RUN apt-get install -y --no-install-recommends dbus-x11 procps psmisc lxlauncher lxtask kmod xz-utils

# OpenGL / MESA
# adds 68 MB to image, disabled
#RUN apt-get install -y mesa-utils mesa-utils-extra libxv1

# Language/locale settings
# replace en_US by your desired locale setting, 
# for example de_DE for german.
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen && \
    apt-get install -y locales && \
    update-locale --reset LANG=$LANG

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs \
    menu-xdg mime-support desktop-file-utils


# GTK 2 settings for icons and style
# GTK 3 settings for icons and style
# wallpaper
RUN echo '\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.gtkrc-2.0 && \
\
mkdir -p /etc/skel/.config/gtk-3.0 && \
echo '\n\
[Settings]\n\
gtk-theme-name="Raleigh"\n\
gtk-icon-theme-name="nuoveXT2"\n\
' > /etc/skel/.config/gtk-3.0/settings.ini && \
\
mkdir -p /etc/skel/.config/pcmanfm/LXDE && \
echo '\n\
[*]\n\
wallpaper_mode=stretch\n\
wallpaper_common=1\n\
wallpaper=/usr/share/lxde/wallpapers/lxde_blue.jpg\n\
' > /etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf

# startscript to copy dotfiles from /etc/skel
# runs either CMD or image command from docker run
RUN echo '#! /bin/sh\n\
[ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n\
unset DEBIAN_FRONTEND \n\
exec $*\n\
' > /usr/local/bin/start && chmod +x /usr/local/bin/start 

ENTRYPOINT ["/usr/local/bin/start"]
CMD ["startlxde"]

ENV DEBIAN_FRONTEND newt
