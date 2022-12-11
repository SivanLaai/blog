---
title: apt重新安装配置
date: 2021-09-16 16:05:52
permalink: /pages/5772b7/
categories:
  - 问题总结
tags:
  - 踩坑
---
## 7.apt重新配置
#### （1）修复Python
当前的系统python如果有错误了，也需要一起修复，这个版本的python不能随便的更改，需要从一个正常的linux系统下把python复制出来。
```bash
# 版本正常的python3.6
mkdir python3.6
cd python3.6
mkdir python3.6-lib
mkdir python3-lib
mkdir x86_64-linux-gnu
cp -rf /usr/bin/python3.6* ~/python3.6
cp -rf /usr/lib/python3.6/* ~/python3.6/python3.6-lib
cp -rf /usr/lib/python3/* ~/python3.6/python3-lib
cp -rf /usr/lib/x86_64-linux-gnu/*apt* ~/x86_64-linux-gnu/
cd ..
tar zcvf python3.6.tar.gz python3.6
scp python3.6.tar.gz user@localhost:~
# 待修复的linux主机
tar zxvf python3.6.tar.gz
cd python3.6
sudo cp -rf python3.6 /usr/bin
sudo cp -rf python3.6m /usr/bin
sudo cp -rf python3.6-lib/* /usr/lib/python3.6
sudo cp -rf python3-lib/* /usr/lib/python3
```
#### （2）修复动态库
```bash
dpkg -l apt
```
![微信截图_20210915181441](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/wiki/微信截图_20210915181441.jaogs5xn7dk.png)

其中版本是```2.0.2ubuntu0.2```，下载对应的安装包并安装：

```bash
# 安装apt
wget http://mirrors.edge.kernel.org/ubuntu/pool/main/a/apt/apt_2.0.2ubuntu0.2_amd64.deb
sudo dpkg -i apt_2.0.2ubuntu0.2_amd64.deb
# 有时候提示缺少libapt-pkg6.0.so
# 安装apt-pkg依赖
wget http://mirrors.edge.kernel.org/ubuntu/pool/main/a/apt/libapt-pkg6.0_2.0.2ubuntu0.2_amd64.deb
sudo dpkg -i libapt-pkg6.0_2.0.2ubuntu0.2_amd64.deb
```

#### （3）测试apt
```bash
sudo apt update
```
