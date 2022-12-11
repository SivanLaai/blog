---
title: docker教程
date: 2022-04-02 19:07:09
permalink: /pages/85892f/
categories:
  - 教程
tags:
  - docker
---
# docker教程

## docker安装
#### 卸载老版本docker
```bash
 sudo apt-get remove docker docker-engine docker.io containerd runc
```

#### 设置apt仓库
* 1.更新apt包索引并且安装相关依赖允许apt使用https更新
```bash
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
* 2.增加Docker官方GPG Key
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
* 3.设置apt docker稳定仓库设置
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
#### 安装Docker引擎
* 1.更新apt包索引并且安装Docker引擎
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
* 2.验证docker是否成功安装
```bash
sudo docker run hello-world
```
* 3.设置apt docker稳定仓库设置
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
#### 参考文档
[Install Docker Engine on Ubuntu | Docker Documentation](https://docs.docker.com/engine/install/ubuntu/)

## Docker Compose安装 
### Linux
#### 安装Docker Compose
* 1.下载docker compose可执行文件
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
* 2.设置可执行权限
```
sudo chmod +x /usr/local/bin/docker-compose
```

## qBittorrent Docker运行
### Docker Compose 配置qBittorrent
#### 新建项目
* 1.进入home目录，新建项目qBittorrent
```bash
cd ~
mkdir qBittorrent
cd qBittorrent
```
* 2.进入项目文件目录，新建配置文件```docker-compose.yml```，配置下载端口，qBittorrent相关目录
```bash
version: "3"

services:
  qbittorrent:
    image: emmercm/qbittorrent:latest
    restart: unless-stopped
    ports:
      - 8080:8080
      - 5463:5463/tcp
      - 5463:5463/udp
    volumes:
      - ./config:/config
      - ./data:/data
      - ./downloads:/downloads
      - ./incomplete:/incomplete
```
#### 运行项目
1.下载并创建镜像
```bash
docker-compose up
```
* 2.运行镜像
```bash
docker-compose start
```