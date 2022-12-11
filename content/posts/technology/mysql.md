---
title: 数据库配置
date: 2022-02-25 21:41:04
permalink: /pages/fba1ab/
categories:
  - 教程
tags:
  - mysql
  - 数据库
---
## mysql数据库

### mysql忘记密码

#### （1）修改配置文件免密

```
sudo vim /etc/mysql/my.cnf
```
```
[mysqld]
skip-grant-tables
```
#### （2）重启mysql

```
sudo service mysql restart
```
#### （3）修改初始密码

```
mysql -u root
use mysql;
update user set password=password("test@123") where user="root";
```

### mysql root帐号不能登录

#### （1）修改配置文件免密

看mysql忘记密码的第一步
#### （2）更新ip访问权限

```
flush privileges;
alter user 'root'@'localhost' identified by 'test@123';
flush privileges;
commit;
```

### mysql 创建数据库
```
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

### mysql 创建用户开启外网权限
- 打开配置文件
```
sudo vim /etc/mysql/my.cnf
```
- 修改绑定ip
```
[mysqld]
bind-address=0.0.0.0
```
- 具体命令
```
CREATE USER 'username'@'%' IDENTIFIED BY 'password';
# 所有的数据库都可以在外网访问
GRANT ALL PRIVILEGES ON *.* TO 'username'@'%';
FLUSH PRIVILEGES;
```