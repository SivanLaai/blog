---
title: 系统配置和问题
date: 2021-09-16 16:05:49
permalink: /pages/66a644/
categories:
  - 教程
tags:
  - linux
  - windows
---
# Linux
## /usr/bin/dpkg returned an error code (1)
### 解决dpkg错误
```bash
cd /var/lib/dpkg
sudo mv info info.baksudo
mkdir info
```

## 添加用户名和添加sudo

### 添加用户名

```bash
sudo useradd -m -d /data/username -s /bin/zsh username
```

### 修改密码

```bash
sudo passwd username
```

### 添加sudoers

```bash
vi /etc/sudoers
#添加用户
username    ALL=(ALL:ALL) ALL
```

## Ubuntu安装Linux开发包

```bash
sudo apt-get install build-essential
```

## 根据关键字把进程杀掉

```bash
kill -9 $(ps -ef|grep keyword|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')
```

## linux永久挂载硬盘
#### 查看当前的硬盘状态，可以知道硬盘的分区
```bash
sudo fdisk -l
```
#### 修改配置
```bash
sudo vim /etc/fstab
```
```bash
# 添加如下信息挂载硬盘
/dev/sdb1 /mnt/data ntfs-3g defaults 0 0
```
#### 挂载硬盘
```bash
mkdir -p /mnt/data
sudo mount -a
```
## linux开机自启动并服务化
### Ubuntu
#### 开机启动
#### 系统服务化（以qbittorrent服务化为例）
不要在后面添加#的注释，不然会导致未知错误
- 配置文件```/lib/systemd/system/qbittorrent.service```
```bash
[Unit]
Description=qbittorrent-nox service #服务描述
Documentation=man:qbittorrent-nox(1)

[Service]
User=username   #用户
Group=usergroup  #用户组
UMask=0000  #权限777
Type=simple
#ExecStartPre=-cd /home/<span class="hljs-built_in">test</span>/ #启动前执行
#WorkingDirectory=/home/<span class="hljs-built_in">test</span>/ #工作目录
ExecStart=/usr/bin/qbittorrent-nox #启动时执行
ExecReload=/bin/kill -SIGHUP $MAINPID #重启时执行
ExecStop=/bin/kill -SIGINT $MAINPID #停止时执行

[Install]
WantedBy=default.target

```
- 服务常用命令集合
```bash
# 开机启动
systemctl enable qbittorrent

# 关闭开机启动
systemctl disable qbittorrent

# 启动服务
systemctl start qbittorrent

# 停止服务
systemctl stop qbittorrent

# 重启服务
systemctl restart qbittorrent

# 查看服务状态
systemctl status qbittorrent
systemctl is-active sshd.service

# 结束服务进程(服务无法停止时)
systemctl kill qbittorrent
```
#### 用户服务化（以v2ray服务化为例，不需要sudo也可以启动，在某个用户登录的时候启动）
不要在后面添加#的注释，不然会导致未知错误
- 配置文件~/.config/systemd/user/v2ray.service```
```
[Unit]
Description=keep v2ray's servie alive

[Service]
Type=simple
Restart=always
WorkingDirectory=~/v2ray/
ExecStart=bash v2ray.sh
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

[Install]
WantedBy=default.target

```
- 启动服务在原来的基础上加```--user```
```
```bash
# 开机启动
systemctl --user enable --now v2ray
# 关闭开机启动
systemctl --user disable --now v2ray

```

## linux安装常见中文字体
### Ubuntu
- 打包Windows字体
```bash
mkdir -p winfonts
cp -rf C:/Windows/Fonts winfonts
压缩winfonts为winfonts.zip
```
- 上传到linux
```bash
scp winfonts.zip username@host:~
```
- 安装字体
```bash
unzip -n -d /usr/share/fonts winfonts.zip
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -f -v
```
- 检查中文字体
```
fc-list :lang=zh
```
# Windows
## 给Neovim添加右键文件夹、文件以及右键空白区域三种菜单
![](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/note/20220408200405.png)

##### 右键文件夹
- 添加如下值

```
计算机\HKEY_CLASSES_ROOT\Directory\shell\使用Neovim打开
```
- 添加Icon
在```使用Neovim打开```空白处添加字符串项```Icon```设置值为```"D:\Program Files\Neovim\bin\gnvim.exe"```
- 添加打开命令
在```使用Neovim打开```添加子项```command```，设置值为```"D:\Program Files\Neovim\bin\gnvim.exe" -qwindowgeometry 1310x650+20+20 "%1"```
##### 右键文件
- 添加如下值

```
计算机\HKEY_CLASSES_ROOT\*\shell\使用Neovim打开
```
- 添加Icon
在```使用Neovim打开```空白处添加字符串项```Icon```设置值为```"D:\Program Files\Neovim\bin\gnvim.exe"```
- 添加打开命令
在```使用Neovim打开```添加子项```command```，设置值为```"D:\Program Files\Neovim\bin\gnvim.exe" -qwindowgeometry 1310x650+20+20 "%1"```

##### 右键文件
- 添加如下值

```
计算机\HKEY_CLASSES_ROOT\Directory\Background\shell\使用Neovim打开
```
- 添加Icon
在```使用Neovim打开```空白处添加字符串项```Icon```设置值为```"D:\Program Files\Neovim\bin\gnvim.exe"```
- 添加打开命令
在```使用Neovim打开```添加子项```command```，设置值为```"D:\Program Files\Neovim\bin\gnvim.exe"```
##### 参考文档
- [使用注册表编辑win10鼠标右键菜单，详细解释（右键文件夹、文件以及右键空白区域下三种情况）_鸾镜朱颜暗换的博客-CSDN博客_桌面右键菜单注册表](https://blog.csdn.net/qq_34769162/article/details/117068877)
- [contextmenu - How add context menu item to Windows Explorer for folders - Stack Overflow](https://stackoverflow.com/questions/20449316/how-add-context-menu-item-to-windows-explorer-for-folders)
