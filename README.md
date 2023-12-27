# Obsidian写hugo博客，快捷键```Crtl + U```发布并自动部署。
本人原来使用的博客是vuepress + vdoing，后来在使用的过程中发现这个博客非常的笨重，没有多少的文章编译下来就需要一会时间。

以前使用过wordpress，这个用来建站是很不错的选择用来做博客的话需要有自己的服务器，并且对于Markdown文档的支持不是很好，现在的博客基本上是使用markdown来写，所以不考虑wordpress。

然后了解到Hugo的出现，看了他的优势，打包速度快，几乎不受文件多少的影响。为了更好专注在写文章，同时可以不用每次繁琐的命令行操作和发布，本教程实现了快捷键操作的一键发布。

文章内容所见即所得。写完文章后快捷键 ```Crtl + U```快速发布文章，然后等待GitHub Action部署完成，刷新页面就可以看到新文章，如下为展示的效果：

[点击预览](https://blog.laais.cn/video/obsdidian_hugo_auto_deploy.mp4)


# 快速开始
现在已经把整套流程打通了，直接参考下面的步骤，可以实现Obsidian写博客+自动发布和部署。
- 下载([Obsidian](https://obsidian.md/))并安装
- 下载安装[Git-Bash](https://www.git-scm.com/downloads)
-  配置[Git - 生成 SSH 公钥 (git-scm.com)](https://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E7%94%9F%E6%88%90-SSH-%E5%85%AC%E9%92%A5)
- 创建github新项目为：你的用户名.github.io，如```SivanLaai.github.io```，其中SivanLaai为我的用户名
- 克隆本项目并切换分支
```
git clone --recursive git@github.com:SivanLaai/blog.git && cd blog
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
**建议新手根据自己的时间来衡量是否加入，不然折腾起来也挺费劲，容易遇到这种问题。确实有时间的可以尝试**

本教程中使用的hugo主题是papermod，同时加入了评论功能，使用的是Waline评论系统，比较推荐使用这个评论系统，支持自建后端也可以使用免费的后端云服务，有评论管理功能，安全，支持登录和匿名模式。

对于Waline的详细使用请看[官方教程](https://waline.js.org/guide/get-started/)，根据官方教程配置好Waline后端好，在```config.yml```里面如下：
```
waline:
    serverUrl: "WALINE_SERVER_URL"
```
把```WALINE_SERVER_URL```替换成你的Waline服务地址就可以。

# 参考文章
1. [Obsidian + Hugo 最佳配置推荐 | 胡说 (zhangyingwei.com)](https://blog.zhangyingwei.com/posts/2022m4d12h13m13s22/)
2. [Hugo 博客写作最佳实践 | 胡说 (zhangyingwei.com)](https://blog.zhangyingwei.com/posts/2022m4d11h19m42s28/)
3. [使用Github Actions对Hexo博客自动部署 - zu1k](https://zu1k.com/posts/coding/use-github-actions-to-auto-deploy-hexo/#%E5%89%8D%E8%A8%80)
