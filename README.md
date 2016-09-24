# x11docker/lxde

Dockerfile containing LXDE desktop
 - Run LXDE desktop in docker. 
 - Use x11docker to run image. 
 - Get x11docker and x11docker-gui from github: 
https://github.com/mviereck/x11docker 

# Example commands: 
 - x11docker --desktop  x11docker/lxde 
 - x11docker x11docker/lxde pcmanfm
 - x11docker --xephyr --desktop x11docker/lxde
 - x11docker --xpra x11docker/lxde pcmanfm
 
 To create a persistent home folder preserving your settings:
 - x11docker --xephyr --desktop --hostuser --home x11docker/lxde
