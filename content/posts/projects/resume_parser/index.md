---
title: 简历解析软件安装
date: 2021-08-30 20:25:51
categories:
  - 项目
tags:
  - 简历解析
---
## 1.安装selenium
### chrome安装
```bash
sudo apt-get install libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ./google-chrome*.deb
sudo apt-get install -f
```
### 配置chromedriver
（1）下载驱动
去官网下载：http://chromedriver.storage.googleapis.com/index.html
[点击](http://chromedriver.storage.googleapis.com/92.0.4515.43/chromedriver_linux64.zip)
（2）安装驱动
复制到对应的目录运行
### 配置selenium
```bash
pip install selenium
```

## 2.安装uwsgi
### 配置文件uwsgi.ini
```ini
#uwsgi.ini
[uwsgi]          
http = 0.0.0.0:8010                   
chdir = /home/jianli/resume_service/services                                                                                                           
pythonpath = /home/jianli/venv/bin/python                                                                                                                                     
wsgi-file = resume_parser.py                                                                                                                                                
buffer-size = 40960                                                                                                                                                                                              
callable = app                                                                                                                                                                  
processes = 1                                                                                                                                                                                
stats = 127.0.0.1:9191
```
### 安装和运行uwsgi
```zsh
pip install uwsgi
uwsgi uwsgi.ini
```

## 3.安装supervisor
### 配置supervisor
```bash
http://supervisord.org/installing.html
pip install supervisor
echo_supervisord_conf > supervisord.conf
supervisord -c supervisor.conf
```
### 启动停止supervisor
```bash
supervisorctl update 重新加载配置
supervisorctl reload 重新启动所有程序
supervisorctl status 查看状态
```
### supervisor问题
#### 1.supervisorctl出现http://localhost:9001 refused connection
设置serverurl：
```bash
[supervisorctl]                                                                                                                                              
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket                                                                                 
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket                                                                              
;username=chris              ; should be same as http_username if set                                                                                        
;password=123                ; should be same as http_password if set                                                                                        
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")                                                                                        
;history_file=~/.sc_history  ; use readline history if availabl
```
#### 2.supervisord配置uwsgi后，调用接口会启动新的服务
重新设置uwsgi如下：
```bash
[uwsgi]                                                                                                                                                                                    
http = 0.0.0.0:8010                                                                                        
virtualenv = /home/jianli/venv                                                                             
wsgi-file = /home/jianli/resume_service/services/resume_parser.py                                          
buffer-size = 40960                                                                                        
callable = app                                                                                             
processes = 1                                                                                              
thread = 1
```
## 4.安装libreoffice
### 下载安装
```bash
wget https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/7.1.5/deb/x86_64/LibreOffice_7.1.5_Linux_x86-64_deb.tar.gz
```
(安装说明)[https://zh-cn.libreoffice.org/get-help/install-howto/]
### 字体安装
```bash
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-serif/SubsetOTF/SourceHanSerifCN.zip
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Bold.otf
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-ExtraLight.otf
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Heavy.otf
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Light.otf
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Medium.otf
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Normal.otf
wget https://mirrors.tuna.tsinghua.edu.cn/adobe-fonts/source-han-sans/SubsetOTF/CN/SourceHanSansCN-Regular.otf
unzip SourceHanSerifCN.zip
mv SourceHanSerifCN SourceHan
mv *.otf SourceHan
sudo mv SourceHan /usr/share/fonts
mkfontscale
fc-cache -fv 
# 如果提示 fc-cache: command not found
# 在Ubuntu下运行如下命令
# sudo apt-get install fontconfig
# 在cent os下运行如下命令
# yum install fontconfig
```
