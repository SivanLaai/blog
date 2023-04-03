---
title: '搭建备用梯子：V2Ray + WebSocket + TLS + CloudFlare'
date: '2020-01-12 20:20:00'
updated: '2020-01-15 19:30:00'
categories: 
 - 技术
author: prinsss
tags:
  - V2Ray
---

2020 年的第一篇博文竟然是讲虚拟砖混结构建筑物逾越技术的，感觉有点微妙。

年终总结啊，在写了在写了，明年就发。

<!--more-->

因为嫌麻烦，我这几年基本用的都是现成的代理服务（俗称机场）。这样虽然不用担心自己机器 IP 被墙、速度方面基本有保障、节点也多，不过俗话说不要把鸡蛋放在一个篮子里，自建一个代理服务器备用还是很有必要的。

这几年翻墙技术似乎也发展了不少（是吗？），这次我选择的方法是 V2Ray + WebSocket + TLS + CloudFlare 中转：速度不重要，隐蔽性、抗干扰性第一。这么几层裹上去，除非真的掐网线搞大局域网，不然应该还是能撑个一段时间。

正文开始前先提个醒，本文不是小白教程，就是随手记录一下，所以我会假定你有一定的基础知识与操作经验。

## 1. 安装 V2Ray

除非你是真的小白零经验，或者「能用就好」主义的忠实信奉者，不然我是不推荐你一上来就直接使用网上那些「一键脚本」的。

就算一键脚本再怎么优秀再怎么便利，至少也应该亲自手动操作一次，了解一下大致的流程。如果我想要做某件事，应该进行哪些操作，脚本会替我完成哪些操作，这些自动化操作是不是符合自己的预期（尤其是脚本是其他人写好的情况下），最起码这些东西得心里有数。

脚本写出来就是帮我们自动完成一些繁琐的操作的，其存在当然有意义，不然每台机器上都手动操作一遍过去，不得累死？用肯定是要用，我所不赞成的只是在不了解这个脚本的情况下瞎用。

线上服务器搭建 LNMP 环境时我也经常用 [OneinStack](https://oneinstack.com/) 这样的一键包，很方便。而且它的源码我也都看过，很清楚它能干嘛、会干嘛。也知道它自带的 `vhost.sh` 虚拟主机管理脚本虽然看起来挺友好，但其修改出来的东西经常惨不忍睹，所以服务器上 Nginx 的配置我从来不用它，都是自己管理的。

总的来说就是可以用傻瓜式脚本，但咱也不能真成傻瓜了，对吧。

----------

好了不说废话，来安装 V2Ray。

安装方法有很多，这里就直接用官方提供的脚本：

```bash
bash <(curl -L -s https://install.direct/go.sh)
```

脚本会自动安装这些东西：

- `/usr/bin/v2ray/v2ray` V2Ray 程序
- `/usr/bin/v2ray/v2ctl` V2Ray 工具
- `/etc/v2ray/config.json` 配置文件
- `/usr/bin/v2ray/geoip.dat` IP 数据文件
- `/usr/bin/v2ray/geosite.dat` 域名数据文件
- `/etc/systemd/system/v2ray.service` Systemd Service
- `/etc/init.d/v2ray` SysV 启动脚本

## 2. 配置 V2Ray 服务端

虽然严格来说 V2Ray 并不分客户端和服务端……反正就是那个意思啦。

编辑配置文件 `/etc/v2ray/config.json`：

```javascript
{
  "inbounds": [{
    "port": 10086,
    // 因为还要用 Nginx 反代，这里直接监听本地就行
    "listen": "127.0.0.1",
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          // 用户 UUID，自己随机弄一个
          "id": "23ad6b10-8d1a-40f7-8ad0-e3e35cd38297",
          "level": 1,
          "alterId": 64
        }
      ]
    },
    "streamSettings": {
      // 指定底层传输方式为 WebSocket
      "network": "ws",
      "wsSettings": {
        // 在哪个路径上提供 WS 服务，可自定义
        "path": "/whatever"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [
      {
        // 默认规则，禁止访问服务器内网
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "blocked"
      }
    ]
  }
}
```

上述配置是直接基于默认配置修改的，V2Ray 的配置很灵活，还有很多可以完善的地方。不过配置调优并不是本文的重点，所以这里按下不表，有兴趣可以自行阅读官方文档。

## 3. 运行 V2Ray

配置完了，运行一下：

```bash
systemctl start v2ray
```

如果你的服务器不用 Systemd：

```bash
service v2ray start
# 要么
/etc/init.d/v2ray start
# 或者手动运行
/usr/bin/v2ray/v2ray -config /etc/v2ray/config.json
```

测试一下有没有跑起来：

```bash
curl -i http://127.0.0.1:10086/whatever
```

```text
HTTP/1.1 400 Bad Request
Content-Type: text/plain; charset=utf-8
Sec-Websocket-Version: 13
X-Content-Type-Options: nosniff
Date: Sun, 12 Jan 2020 11:45:14 GMT
Content-Length: 12

Bad Request
```

注意 curl 访问的端口和路径要和上面 V2Ray 中配置的一致，出现 400 Bad Request 就对了。

## 4. 配置 Nginx

毕竟要隐蔽嘛，最好是选一个已经上线的正常网站，悄咪咪地把其中一个路径反代到我们的 V2Ray 上。

网上不少 V2Ray + WebSocket + TLS 的教程里，Web 服务器 + SSL 证书的配置都是重头戏。可如果你平时就有在捣鼓网站的话，这些实在是都不算啥……所以我这里也就一笔带过了。

以 Nginx 为例，找个合适的 `server {}` 块添加以下内容（这重定向语法够蛋疼的）：

```nginx
location /whatever {
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
```

注意 `location` 的路径要和上面 V2Ray 里配置的一样。

最后完整的 Nginx 配置大概类似这样：

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;
    index index.html index.htm index.php;
    root /data/wwwroot/example;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers EECDH+AESGCM:EDH+AESGCM;

    location ~ [^/]\.php(/|$) {
        fastcgi_pass unix:/dev/shm/php-cgi.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
    }

    location /whatever {
        # ...
    }
}
```

表面看上去像个正常 PHP 网站，`/whatever` 里才是大有乾坤。

再把路径和网站内容搞得唬人一点，我寻思隐蔽性方面应该是没问题的。

## 5. 配置 CloudFlare

呃，这个就不用讲什么了吧。还不说声多谢 CloudFlare 哥？

CDN 配置完了再用 curl 测试一下：

```bash
curl -i https://example.com/whatever
```

```text
HTTP/2 400
date: Sun, 12 Jan 2020 08:44:07 GMT
content-type: text/plain; charset=utf-8
content-length: 12
sec-websocket-version: 13
x-content-type-options: nosniff
cf-cache-status: DYNAMIC
expect-ct: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct" server: cloudflare

Bad Request
```

同样也是出现 400 Bad Request 就对了。

如果你像我上面一样在 Nginx 中配置了 `$http_upgrade = "websocket"` 的判断的话，这里返回的会是用于伪装的那个页面（而且 Nginx 的 `$http_upgrade` 变量不知道是按什么赋值的，直接 `curl --header "Upgrade: websocket"` 的话还不认，怪得很）。可以使用 `wscat` 来测试：

```bash
wscat -c wss://example.com/whatever
```

```text
Connected (press CTRL+C to quit)
```

## 6. 配置 V2Ray 客户端

客户端配置文件大概改成这样：

```javascript
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [{
    // 本地代理配置
    "port": 1080,
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": false,
      "ip": "127.0.0.1"
    }
  }],
  "outbounds": [{
    "protocol": "vmess",
    "settings": {
      "vnext": [
        {
          // 套过 CloudFlare 的网址
          "address": "example.com",
          "port": 443,
          "users": [
            {
              // id 和 alterId 必须和服务端上配置的一样
              "id": "23ad6b10-8d1a-40f7-8ad0-e3e35cd38297",
              "alterId": 64
            }
          ]
        }
      ]
    },
    "streamSettings": {
      // 传输协议为 WebSocket
      "network": "ws",
      // 底层传输安全为 TLS
      "security": "tls",
      "wsSettings": {
        // 路径要和上面设置的一样
        "path": "/whatever"
      }
    }
  }],
  "policy": {
    "levels": {
      "0": {"uplinkOnly": 0}
    }
  }
}
```

上述客户端配置同样也是简化的，路由、DNS 什么的都没设置。

当然，我估计桌面用户基本上用的都是各种图形客户端，不然可不是折腾自己嘛。以 Windows 上的 v2rayN 客户端为例，你可以这样添加服务器：

![v2rayn-client-ws-tls-config](https://prinsss.github.io/v2ray-ws-tls-cloudflare/v2rayn-client-ws-tls-config.png)

不出意外就可以正常使用了。

## 常见问题
### TUN模式，开启热点连接暴增

> 1.  开启热点分享功能，此时系统网络设置中会生成一个网卡
> 2.  开启 TUN 模式
> 3.  进入系统网络设置，在 Clash 网卡右键选择属性，选择共享标签页
> 4.  勾选“允许其他网络用户通过此计算机的 Internet 连接来连接”
> 5.  在“家庭网络连接”选择框中选择第 1 步生成的网卡

[![networdk-adaptor.jpg](https://file.leey.tech/d/OneDrive-P1/2022/04/21/DEycqBZ9/1650554539.jpg "networdk-adaptor.jpg")](https://file.leey.tech/d/OneDrive-P1/2022/04/21/DEycqBZ9/1650554539.jpg "networdk-adaptor.jpg")


**参考链接：**

- [WebSocket+TLS+Web · V2Ray 配置指南|V2Ray 白话文教程](https://toutyrater.github.io/advanced/wss_and_web.html)
- [配置文件 · Project V 官方网站](https://www.v2ray.com/chapter_02/)
- [使用Cloudflare中转V2Ray流量 · 233boy/v2ray Wiki](https://github.com/233boy/v2ray/wiki/%E4%BD%BF%E7%94%A8Cloudflare%E4%B8%AD%E8%BD%ACV2Ray%E6%B5%81%E9%87%8F)
- [CFW TUN 模式 移动热点冲突 - Leey's](https://blog.leey.tech/2022/04/20/cfw-tun-hotspot.html)
