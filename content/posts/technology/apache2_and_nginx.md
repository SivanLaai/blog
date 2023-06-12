---
title: web容器的使用和反向代理
date: 2022-05-03 10:47:44
permalink: /pages/317a9f/
categories:
  - 教程
tags:
  - 反向代理
  - 网站证书
---
# apache常见问题
### 配置apache2文件简单服务器
打开配置文件
```bash
sudo vim /etc/apache2/sites-available/000-default.conf
```
修改内容为
```bash
  Alias /e6ecni3_Sivan "/var/www/html/"
  <Directory /var/www/html/">
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
  </Directory>
```
删除```/var/www/html```
```bash
sudo rm -rf /var/www/html
#软链html为你的共享文件目录
```
### 访问apache2服务器默认指向index.php

  ```bash
删除浏览器的访问记录就可以
  ```
### 在apache2中配置反向代理
**反向代理**服务器位于用户与目标服务器之间，但是对于用户而言，反向代理服务器就相当于目标服务器，即用户直接访问反向代理服务器就可以获得目标服务器的资源。同时，用户不需要知道目标服务器的地址，也无须在用户端作任何设定。反向代理服务器通常可用来作为Web加速，即使用反向代理作为Web服务器的前置机来降低网络和服务器的负载，提高访问效率。
其作用如下表示：
![](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/note/20220322171953.png)

#### 开启模块支持

```bash
sudo a2enmod rewrite
sudo a2enmod lbmethod_byrequests
sudo a2enmod proxy_balancer
sudo a2enmod proxy_http
sudo a2enmod proxy
```
#### 添加反向代理设置
```bash
#sites-available/example.conf
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin sivan@localhost
	# Para qbittorrent
	RewriteEngine on
	RewriteRule             ^/torrent$      "/torrent/$1" [R]
	ProxyPass               /torrent/       http://127.0.0.1:8080/
	ProxyPassReverse        /torrent/       http://127.0.0.1:8080/
	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

```

#### 启动服务
```bash
sudo a2ensite example.conf
sudo service apache2 restart
```

## apache 添加ssl证书并反向代理
- 开启ssl模块
```bash
sudo a2enmod ssl
```
- 配置证书```site.conf```
```bash
LoadModule proxy_module modules/mod_proxy.so                                  
<IfModule mod_ssl.c>            
        <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost                                                                
                                                                                        
                RewriteEngine on
  
                ProxyPass               /       http://127.0.0.1:8360/
                ProxyPassReverse        /       http://127.0.0.1:8360/

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on
                SSLCertificateFile      /etc/apache2/ssl/cloud.laais.cn.pem
                SSLCertificateKeyFile /etc/apache2/ssl/cloud.laais.cn.key
                SSLCertificateChainFile /etc/apache2/ssl/cloud.laais.cn.crt
				SSLCACertificatePath /etc/apache2/ssl
                SSLCACertificateFile /etc/apache2/ssl.crt/root_bundle.crt                                        
        </VirtualHost>                                                          
</IfModule>  

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

```

## apache 配置websocket代理

```bash
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
<VirtualHost *:80>
        ServerName www.hfsurrogacy.com

        ServerAdmin webmaster@hfsurrogacy.com
        DocumentRoot /var/www/html
        <Directory /var/www/html>
            AllowOverride All
            Require all granted
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <LocationMatch "/web">
            ProxyPass http://127.0.0.1:10086/web upgrade=WebSocket
            ProxyAddHeaders Off
            ProxyPreserveHost On
            RequestHeader set Host %{HTTP_HOST}s
            RequestHeader set X-Forwarded-For %{REMOTE_ADDR}s
        </LocationMatch>

</VirtualHost>
```


## 阿里云ssl证书安装错误
- 根据阿里云的教程[在Apache服务器上安装SSL证书 (aliyun.com)](https://help.aliyun.com/document_detail/98727.html?spm=0.2020520163.help.dexternal.172bmN0amN0aZT)
1.在服务器上更新证书apache2会报错
（1）错误1：```AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globa```
在```apache.conf```最后添加如下：
```
...
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet                                                                                                                                                   
ServerName 127.0.0.1 
```

（2）错误2：```Action 'start' failed.```
看日志提示```SSL Library Error: error:0A0000B1:SSL routines::no certificate assigned```
- 解决方案
下载这两处的文件然后把其他文件里面的pem文件更新到```site.conf```中
![](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20221212231557.png)


# Nginx常见问题
### 配置nginx反向代理和重定向
- 打开配置文件
```bash
sudo vim /etc/nginx/conf.d/jellyfin.conf
```

- 添加如下内容（访问http://host/video/*.html 可反向代理重定向到http://host:8096/*.html）：
```bash
	set $jellyfin 127.0.0.1;
    location /video {
        # Proxy main Jellyfin traffic
	rewrite ^/video/(.*)$ /$1 break;
        proxy_pass http://$jellyfin:8096; 
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-Host $http_host;

        # Disable buffering when the nginx proxy gets very resource heavy upon streaming
        proxy_buffering off;
    }

    # location block for /web - This is purely for aesthetics so /web/#!/ works instead of having to go to /web/index.html/#!/
    location = /video/web/ {
        # Proxy main Jellyfin traffic
        proxy_pass http://$jellyfin:8096/web/index.html;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
    }

```

### 配置wordpress支持
- 打开配置文件
```bash
sudo vim /etc/nginx/sites-available/default
```

- 添加如下内容（支持.htaccess和php）：
```bash
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
                # support .htaccess
                if (-f $request_filename/index.html){
                        rewrite (.*) $1/index.html break;
                }
                if (-f $request_filename/index.php){
                        rewrite (.*) $1/index.php;
                }
                if (!-f $request_filename){
                        rewrite (.*) /index.php;
                }
        }
		
        location /login {
                proxy_redirect off;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

                set $is_v2ray 0;
                if ($http_upgrade = "websocket") {
                    set $is_v2ray 1;
                }

                if ($is_v2ray = 1) {
                    # 仅当请求为 WebSocket 时才反代到 V2Ray
                    proxy_pass http://127.0.0.1:10086;
                }

                if ($is_v2ray = 0) {
                    # 否则显示正常网页
                    rewrite ^/(.*)$ /mask-page last;
                }
        }


        # pass PHP scripts to FastCGI server
        #
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                # With php-fpm (or other unix sockets):
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }

}
```