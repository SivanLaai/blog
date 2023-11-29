---
title: 流式教程
date: 2023-11-29T15:23:38+08:00
draft: true
categories:
  - 教程
tags:
---
# Sunshine

## 下载和安装sunshine

```
wget https://github.com/LizardByte/Sunshine/releases/download/v0.21.0/sunshine-ubuntu-20.04-amd64.deb
sudo apt install -f ./sunshine-ubuntu-20.04-amd64.deb
```
## sunshine服务化

```
mkdir -p ~/.config/systemd/user
vim ~/.config/systemd/user/sunshine.service
```

 - 添加如下内容：
```bash
 [Unit]
Description=Sunshine self-hosted game stream host for Moonlight.
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
ExecStart=<see table>
Restart=on-failure
RestartSec=5s
#Flatpak Only
#ExecStop=flatpak kill dev.lizardbyte.sunshine

[Install]
WantedBy=graphical-session.target
```
-  开机自启
```
systemctl --user start sunshine
systemctl --user enable sunshine
```

## 配置sunshine支持外网

```
vim ~/.config/sunshine.conf
```
 - 添加如下内容：
```bash
origin_web_ui_allowed = wan
```

# Zoretier(p2p)
## 安装
```
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \ if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
```
## 添加组网
```
zerotier-cli join network_id
```

然后在服务器上授权