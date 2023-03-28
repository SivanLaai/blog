---
title: Ubuntu安装VNCServer
date: 2023-03-28T13:48:48+08:00
categories:
tags:
---


### Step1 （安装GNOME桌面）
```bash
sudo apt-get update 
sudo apt-get install gnome-session-flashback 
sudo apt-get install ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal -y
```

### Step2
```bash
sudo apt-get -y install xfonts-100dpi xfonts-100dpi-transcoded xfonts-75dpi xfonts-75dpi-transcoded xfonts-base
```
### Step3
```bash
sudo apt-get install tightvncserver
```
### Step4：配置密码
```bash
vncpasswd
```
### Step5：配置XStartup
```bash
vim ~/.vnc/xstartup
```
内容如下：
```bash
#!/bin/sh
# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
dbus-launch gnome-panel &
dbus-launch gnome-settings-daemon &
metacity &
nautilus &
dbus-launch gnome-terminal &
```
以上配置服务器可能会卡，不卡的配置尝试如下：
```bash
#!/bin/sh
# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
gnome-session &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
gnome-terminal &
```
### Step6:重启TigerVNC
```bash
tightvncserver -kill :1 
reboot 
tightvncserver
```
