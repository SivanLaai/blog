---
title: 软件编译和安装
date: 2022-05-19 13:40:49
permalink: /pages/dd48ab/
lightgallery: true
categories:
  - 教程
tags:
  - 软件编译
  - 软件安装
---
# 软件编译和安装
## qbittorrent编译安装

- 安装依赖
```bash
apt-get install build-essential pkg-config automake libtool git
apt-get install libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev
```
- 安装libtorrent
```bash
git clone https://github.com/arvidn/libtorrent.git
#之前系统版本可直接下载源码使用，18.04需修改include/libtorrent/export.hpp替换boost/config/为boost/config/detail/
#https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_11/libtorrent-rasterbar-1.0.11.tar.gz
cd libtorrent
git checkout origin/RC_1_2
./autotool.sh
./configure CXXFLAGS=-std=c++14
make clean && make -j$(nproc)
make install
```
* 安装qbittorrent
```bash
apt-get install qtbase5-dev qttools5-dev-tools libqt5svg5-dev zlib1g-dev
wget https://github.com/qbittorrent/qBittorrent/archive/release-4.2.5
tar zxvf release-4.1.3.tar.gz
cd qBittorrent-release-4.1.3/
./configure --disable-gui
make clean && make -j$(nproc)
make install
```
## LAMP php7.4安装
#### Ubuntu 18
- 安装
```bash
apt-get install software-properties-common
```
- 添加第三方源
```bash
add-apt-repository ppa:ondrej/php
apt-get update

```
- 安装LAMP环境
```bash
sudo apt update
sudo apt install apache2 mariadb-server libapache2-mod-php7.4
sudo apt install php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl
sudo apt install php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip
```
## LAMP php安装
#### Ubuntu 22
- 安装
```bash
apt-get install software-properties-common
```
- 添加第三方源
```bash
add-apt-repository ppa:ondrej/php
apt-get update

```
- 安装LAMP环境
```bash
sudo apt update && sudo apt upgrade
sudo apt install mariadb-server  php-gd php-mysql php-fpm \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
```
## Neovim 安装
#### Ubuntu
##### PPA安装
- 安装依赖软件
```zsh
sudo apt-get install software-properties-common
## older ubuntu version
sudo apt-get install python-software-properties
```
- 安装发布版本neovim
```bash
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```
##### 编译安装
- 安装编译依赖
```bash
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
```

- 获取源代码
```bash
git clone https://github.com/neovim/neovim
```

- 编译安装neovim

```bash
 cd neovim
 make
 sudo make install
```

- 让neovim支持python和python3

```bash
 sudo apt-get install python3 python3-pip python-pip -y
 pip install neovim
 pip3 install neovim
```
## tmux 安装
#### Ubuntu
##### 编译安装
 获取源代码
```bash
wget https://github.com/tmux/tmux/releases/download/3.3-rc/tmux-3.3-rc.tar.gz
```

- 编译neovim

```bash
 tar -zxvf tmux-3.3-rc.tar.gz
 cd tmux-3.3-rc
 make
 sudo make install
```
## transmission 安装
#### 镜像安装
- 创建文件夹```nextcloud```
```
mkdir transmission
```
- 创建文件```docker-compose.yml```
```yaml
---
version: "2.1"
services:
  transmission:
    image: lscr.io/linuxserver/transmission
    container_name: transmission
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - TRANSMISSION_WEB_HOME=/combustion-release/ #optional
      - USER=transmission #optional
      - PASS=passwd #optional
        #- WHITELIST=iplist #optional
        #- PEERPORT=peerport #optional
        #- HOST_WHITELIST=dnsnane list #optional
    volumes:
      - ./config:/config
      - ./downloads:/downloads
      - ./watch:/watch
    ports:
      - 9091:9091
      - 51413:51413
      - 51413:51413/udp
    restart: unless-stopped


```

- 启动镜像
```
sudo docker-compose up -d
```

#### apt安装
- 安装
```
sudo apt update install transmission-daemon
```
- 修改配置文件
``` # /etc/transmission-daemon/settings.json
    ...
    "rpc-whitelist": "*",
    "rpc-whitelist-enabled": true,
    ...
```

#### web-ui安装
- 安装
```
wget https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control-cn.sh
bash install-tr-control-cn.sh
```


## Selenium配置
- [Webdriver驱动列表]([Install browser drivers | Selenium](https://www.selenium.dev/documentation/webdriver/getting_started/install_drivers/))
#### Windows
- 下载驱动
	- [Edge Webdriver]([Microsoft Edge WebDriver - Microsoft Edge Developer](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/))
	- [Chrome Webdriver](https://chromedriver.storage.googleapis.com/index.html)

- 解压驱动到程序目录
```bash
mkdir selenium_test
cd selenium_test
```

- 启动镜像
```
sudo docker-compose up -d
```

## Jellyfin 安装 并启用硬件加速
#### apt安装
- 所有的Ubuntu发行版本
https://repo.jellyfin.org/releases/server/ubuntu/versions
- 查看当前的GPU设备
```
lspci -k | grep -A 2 -i "VGA"
```
- 禁用nouveau
```
sudo vim /etc/modprobe.d/blacklist_nouveau.conf

# 添加
blacklist nouveau
options nouveau modeset=0

sudo reboot
```
- 搜索Nvidia显卡驱动
```
sudo ubuntu-drivers devices

```
```
# 安装推荐的驱动
modalias : pci:v000010DEd00000FC2sv00001462sd0000275Cbc03sc00i00
vendor   : NVIDIA Corporation
model    : GK107 [GeForce GT 630 OEM]
driver   : nvidia-driver-450-server - distro non-free #server版本的驱动
driver   : nvidia-driver-470-server - distro non-free
driver   : nvidia-340 - distro non-free
driver   : nvidia-driver-418-server - distro non-free
driver   : nvidia-driver-470 - distro non-free recommended #gui版本的驱动
driver   : nvidia-driver-390 - distro non-free
driver   : xserver-xorg-video-nouveau - distro free builtin
```
- 安装驱动
```
sudo apt install nvidia-driver-470-server
#重启然后在jellyfin中设置Nvidia解码
```


#### 镜像安装
- 创建文件夹```jellyfin```
```
mkdir jellyfin
```
- 创建文件```docker-compose.yml```
```yaml
---
version: "3.5"
services:
  jellyfin:
    image: nyanmisaka/jellyfin:latest
    container_name: jellyfin
    user: 1000:1000
    network_mode: "host"
    volumes:
      - ./config:/config
      - ./cache:/cache
      - ./media:/media
      - /path/to/media2:/media2:ro
    restart: "unless-stopped"


```

- 启动镜像
```
sudo docker-compose up -d
# 这种版本可能会导致apache2在转发端口的时候web存在不能访问服务器
```
## Nvidia驱动安装
#### Ubuntu
- 查看驱动
```
sudo dpkg --list | grep nvidia-*
```
- 卸载驱动
```
sudo /usr/bin/nvidia-uninstall 
sudo apt-get --purge remove nvidia-* 
sudo apt-get purge nvidia* 
sudo apt-get purge libnvidia*
```
- 检查驱动是否卸载
```
sudo dpkg --list | grep nvidia-*
# 无任何输出
```
- 安装驱动
```
sudo ubuntu-drivers devices
sudo apt install nvidia-driver-470-server
```
