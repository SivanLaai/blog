---
title: "Obsidian写hugo博客，github自动部署"
date: 2022-12-09T15:41:53+08:00
draft: false
categories:
  - 建站
tags:
  - 博客搭建
  - 自动部署
  - hugo
---

---

本人原来使用的博客是vuepress + vdoing，后来在使用的过程中发现这个博客非常的笨重，没有多少的文章编译下来就需要一会时间。

以前使用过wordpress，这个用来建站是很不错的选择用来做博客的话需要有自己的服务器，并且对于Markdown文档的支持不是很好，现在的博客基本上是使用markdown来写，所以不考虑wordpress。

然后了解到Hugo的出现，看了他的优势，打包速度快，几乎不受文件多少的影响。为了更好专注在写文章，同时可以不用每次繁琐的命令行操作和发布，本教程实现了快捷键操作的一键发布。

文章内容所见即所得。写完文章后快捷键 ```Crtl + U```快速发布文章，然后等待GitHub Action部署完成，刷新页面就可以看到新文章，如下为展示的效果：

<video id="video" controls="" preload="none" style="width: 100%; heigth: 100%">
    <source id="mp4" src="/video/obsdidian_hugo_auto_deploy.mp4" type="video/mp4">
</video>


# 快速开始
现在已经把整套流程打通了，直接参考下面的步骤，可以实现Obsidian写博客+自动发布和部署。
- 下载([Obsidian](https://obsidian.md/))并安装
- 下载安装[Git-Bash](https://www.git-scm.com/downloads)
-  配置[Git - 生成 SSH 公钥 (git-scm.com)](https://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E7%94%9F%E6%88%90-SSH-%E5%85%AC%E9%92%A5)
- 创建github新项目为：你的用户名.github.io，如```SivanLaai.github.io```，其中SivanLaai为我的用户名
- 克隆本项目并切换分支
```
git clone --recursive git@github.com:SivanLaai/blog.git
```
- 进入blog目录，修改git远程仓库为你的github静态博客项目地址
```
git remote set-url origin git@github.com:SivanLaai/SivanLaai.github.io.git
```
- (可选) - 添加Github项目环境变量```WEB_SITE```为你自己的域名如```www.sivanlaai.laais.cn
- 利用obsidian打开blog文件夹，开始写博客
- 快捷键 ```Crtl + U```快速发布文章（利用Obsidian Shell Command插件实现快速发布）
- 打开你的网址，如```sivanlaai.github.io```
# 其他玩法
## 评论功能（可选）
**建议新手根据自己的时间来衡量是否加入，不然折腾起来也挺费劲，容易遇到这种问题。确实有时间的可以尝试

本教程中使用的hugo主题是Loveit，同时加入了评论功能，使用的是Waline评论系统，比较推荐使用这个评论系统，支持自建后端也可以使用免费的后端云服务，有评论管理功能，安全，支持登录和匿名模式，爆吹。

对于Waline的详细使用请看[官方教程](https://waline.js.org/guide/get-started/)，根据官方教程配置好Waline后端好，在```config.yml```里面如下：
```
waline:
    serverUrl: "WALINE_SERVER_URL"
```
把```WALINE_SERVER_URL```替换成你的Waline服务地址就可以。
## 站点统计
针对原版的不算子的统计功能，感觉有点鸡肋，可以尝试加入了其他的站点统计功能
- [umami](https://github.com/umami-software/umami)（开源比较推荐）
- [百度统计——一站式智能数据分析与应用平台 (baidu.com)](https://tongji.baidu.com/web5/welcome/login)

### 自有主机，docker安装Umami网站统计和Waline评论系统

1.创建文件夹
```
mkdir website && cd website
```
2. 创建如下文件运行```docker-compose up -d``` 
```yaml
version: "3"
services:
  db:
    image: mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=PASSWORD
      - MYSQL_PASSWORD=PASSWORD
      - MYSQL_DATABASE=umami
      - MYSQL_USER=user
    command: --default-authentication-plugin=mysql_native_password --transaction-isolation=READ-COMMITTED --binlog-format=ROW #解决外部无法访问
    volumes:
      - ./conf:/etc/mysql/conf.d
      - ./data:/var/lib/mysql
    network_mode: "host"
  unami:
    image: ghcr.io/umami-software/umami:mysql-latest
    network_mode: "host"
    environment:
      DATABASE_URL: mysql://user:PASSWORD@localhost:3306/umami
      DATABASE_TYPE: mysql
      HASH_SALT: replace-me-with-a-random-string
    restart: always

  waline:
    container_name: waline
    image: lizheming/waline:latest
    restart: always
    network_mode: "host"
    volumes:
      - ${PWD}/data:/app/data
    environment:
      TZ: 'Asia/Shanghai'
      MYSQL_HOST: localhost
      MYSQL_DB: waline
      MYSQL_USER: user
      MYSQL_PASSWORD: PASSWORD
      SITE_NAME: "SivanLaai's Blog"
      SITE_URL: 'http://www.laais.cn'
      SECURE_DOMAINS: 'www.laais.cn'
      AUTHOR_EMAIL: 'eamil@163.com'
      SMTP_PASS: SMTP_PASSWORD
      SMTP_USER: qqid@qq.com
      SMTP_SERVICE: QQ
```
3 初始化waline数据库
```sql
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table wl_Comment
# ------------------------------------------------------------

CREATE TABLE `wl_Comment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `comment` text,
  `insertedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(100) DEFAULT '',
  `link` varchar(255) DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `nick` varchar(255) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  `rid` int(11) DEFAULT NULL,
  `sticky` boolean DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT '',
  `like` int(11) DEFAULT NULL,
  `ua` text,
  `url` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table wl_Counter
# ------------------------------------------------------------

CREATE TABLE `wl_Counter` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `time` int(11) DEFAULT NULL,
  `reaction0` int(11) DEFAULT NULL,
  `reaction1` int(11) DEFAULT NULL,
  `reaction2` int(11) DEFAULT NULL,
  `reaction3` int(11) DEFAULT NULL,
  `reaction4` int(11) DEFAULT NULL,
  `reaction5` int(11) DEFAULT NULL,
  `reaction6` int(11) DEFAULT NULL,
  `reaction7` int(11) DEFAULT NULL,
  `reaction8` int(11) DEFAULT NULL,
  `url` varchar(255) NOT NULL DEFAULT '',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table wl_Users
# ------------------------------------------------------------

CREATE TABLE `wl_Users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `display_name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `type` varchar(50) NOT NULL DEFAULT '',
  `label` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `github` varchar(255) DEFAULT NULL,
  `twitter` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `google` varchar(255) DEFAULT NULL,
  `weibo` varchar(255) DEFAULT NULL,
  `qq` varchar(255) DEFAULT NULL,
  `2fa` varchar(32) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
```
4. 验证后台
- umami后台为[localhost:3000](localhost:3000),初始帐号 admin 密码 umami
- waline后台为[localhost:8360](localhost:8360)


# 参考文章
1. [Obsidian + Hugo 最佳配置推荐 | 胡说 (zhangyingwei.com)](https://blog.zhangyingwei.com/posts/2022m4d12h13m13s22/)
2. [Hugo 博客写作最佳实践 | 胡说 (zhangyingwei.com)](https://blog.zhangyingwei.com/posts/2022m4d11h19m42s28/)
3. [使用Github Actions对Hexo博客自动部署 - zu1k](https://zu1k.com/posts/coding/use-github-actions-to-auto-deploy-hexo/#%E5%89%8D%E8%A8%80)