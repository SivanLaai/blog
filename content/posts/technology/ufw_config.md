---
title: 配置ufw
date: 2021-08-30 20:25:51
permalink: /pages/463d8e/
categories:
  - 教程
tags:
  - ufw
  - firewall
---

### Ubuntu UFW 配置
#### （1）查看ufw信息
```bash
sudo ufw status
```
#### （2）激活ufw
```bash
sudo ufw enable
```

#### （3）阻止/允许IP
```bash
# 允许IP
sudo ufw allow from 203.0.113.101
# 阻止IP
sudo ufw deny from 203.0.113.100
```

#### （3）阻止/允许port
```bash
# 允许外部访问端口8080
sudo ufw allow 8080
# 允许某ip访问端口8080
sudo ufw allow from 203.0.113.101 to any port 8080
# 阻止外部访问端口8080
sudo ufw disable 8080
# 阻止某ip访问端口8080
sudo ufw deny from 203.0.113.101 to any port 8080
```

#### （4）阻止/允许ssh
```bash
# 允许
sudo ufw allow OpenSSH
# 阻止
sudo ufw disable OpenSSH
```

#### （5）查看支持的APP，并阻止/允许

```bash
sudo ufw app list | grep Nginx
```

```bash
#Output
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
```

删除NginxFull
```bash
#允许
sudo ufw allow "Nginx Full"
#阻止
sudo ufw deny "Nginx Full"
```

#### （6）删除规则
先查看规则
```bash
sudo ufw status
```
![ufw-delete](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/wiki/ufw-delete.4ppbaio44bu0.png)

选择对应的规则删除，例如第二个规则
```bash
sudo ufw delete 2
```
![ufw-delete1](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/wiki/ufw-delete1.5f82xcwbe600.png)

直接根据规则来删除
```bash
sudo ufw allow from 203.0.113.101 to any port 8080
sudo ufw delete allow from 203.0.113.101 to any port 8080
```
