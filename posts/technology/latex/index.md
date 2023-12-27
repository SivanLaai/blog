# 安装latex

## 安装Latex
### Windows WSL
#### （1）安装WSL
配置WSL
```bash
wsl --install
```

安装WSL-Ubuntu 18.04
```bash
wsl --install -d Ubuntu-18.04 #等待安装完成
```

启动Ubuntu
```bash
wsl bash
```

#### （2）安装TexLive
在线安装
```bash
sudo apt install texlive-full
```

装载Tex的ISO镜像安装
```bash
sudo mkdir /mnt/img
sudo mount -t drvfs G: /mnt/img
sudo mnt/img/install-tl
```

#### （3）配置环境变量使得powershell上可以直接使用
```bash
sudo /usr/local/texlive/2020/bin/x86_64-linux/tlmgr path add
```

#### （4）配置WSL使用windows字体
```bash
sudo apt install fontconfig
```

创建/etc/fonts/local.conf
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/mnt/c/Windows/Fonts</dir>
</fontconfig>
```


---

> 作者: [SivanLaai](https://blog.laais.cn)  
> URL: https://blog.laais.cn/posts/technology/latex/  

