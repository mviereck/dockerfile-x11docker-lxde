# x11docker/lxde

Dockerfile containing LXDE desktop
 - Run LXDE desktop in docker. 
 - Use x11docker to run GUI applications and desktop environments in docker images. 
 - Get [x11docker from github](https://github.com/mviereck/x11docker)

# Command examples: 
 - Single application: `x11docker x11docker/lxde pcmanfm`
 - Full desktop: `x11docker --desktop x11docker/lxde`

# Options:
 - Persistent home folder stored on host with   `--home`
 - Shared host folder with                      `--sharedir DIR`
 - Hardware acceleration with option            `--gpu`
 - Clipboard sharing with option                `--clipboard`
 - Sound support with option                    `--alsa`
 - With pulseaudio in image, sound support with `--pulseaudio`

See `x11docker --help` for further options.

# Extend base image
To add your desired applications, create your own Dockerfile with this image as a base. Example:
```
FROM x11docker/lxde
RUN apt-get update
RUN apt-get install -y midori
```

 # Screenshot
![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde.png "lxde desktop running in Xephyr window using x11docker")
 

