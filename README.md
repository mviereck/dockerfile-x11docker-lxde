# x11docker/lxde

Dockerfile containing LXDE desktop
 - Run LXDE desktop in docker. 
 - Use x11docker to run image to be able to run GUI applications and desktop environments in docker images. 
 - Get [x11docker from github](https://github.com/mviereck/x11docker)

# Example commands: 
 - Single application: `x11docker x11docker/lxde pcmanfm`
 - Full desktop: `x11docker --desktop x11docker/lxde`
  
# Extend base image
To add your desired applications, create your own Dockerfile `mydockerfile` with this image as a base. Example:
```
FROM x11docker/lxde
RUN apt-get update
RUN apt-get install -y firefox
```
Build an image with `docker build -t mylxde - < mydockerfile`. Run desktop with `x11docker --desktop mylxde` or firefox only with `x11docker mylxde firefox`.

 # Screenshot
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")
 

