# x11docker/lxde

Dockerfile containing LXDE desktop
 - Run LXDE desktop in docker. 
 - Use x11docker to run image to be able to run GUI applications and desktop environments in docker images. 
 - Get [x11docker from github](https://github.com/mviereck/x11docker)

# Example commands: 
 - Single application: `x11docker x11docker/lxde pcmanfm`
 - Full desktop: `x11docker --desktop x11docker/lxde`
 
 # Screenshot
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")
 
