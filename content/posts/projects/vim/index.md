---
title: Vim/Neovim-Tmux 一键安装轻量级工作站
date: 2022-04-08 16:14:01
permalink: /pages/732439/
categories:
  - 项目
tags:
  - vim
  - tmux
---

## 添加功能：
### 1.文件管理：插件NerdTree
- 打开文件管理：Crtl + N
- 退出文件管理：Crtl + C

### 2.跳转功能：Ctags\pygments\gtags
- 跳转到定义：Crtl + ]
- 后退：Crtl + T
- Ctrl+\ c    Find functions calling this function
- Ctrl+\ d    Find functions called by this function
- Ctrl+\ e    Find this egrep pattern
- Ctrl+\ f    Find this file
- Ctrl+\ g    Find this definition
- Ctrl+\ i    Find files #including this file
- Ctrl+\ s    Find this C symbol
- Ctrl+\ t    Find this text string

### 3.任意跳转功能，主要是和前一个功能进行补充；JumpAny
- 跳转到定义：cursor移动到关键词 , + j

### 4.搜索功能：LeaderF
- 打开搜索：, + f
- 结果上翻：Crtl + k
- 结果下翻：Crtl + j
- 打开：Enter
- 帮助：Tab

### 5.代码补全：Coc.nvim
- 打开搜索：在对应的关键词后面按tab会提示
- 结果下翻：提示后按Tab可以顺序下翻，或者用Crtl + n
- 结果上翻：提示后Crtl + p
- 选择：Enter

### 6.代码错误修正：Coc.nvim
### 7.**单终端编译和写代码，不用Crtl-z切后台编译**，直接借助tmux和vimux插件实现在一个界面写代码和编译
- 创建tmux：```tmux session -t mytmux```
- 分屏tmux：打开vim后输入```, + v + p```，输入相关的运行命令便可打开命令行
- 运行上一次的命令：需要先运行在```, + v + p```，然后在```, + v + l```便可以运行最后一次的命令
- 切换tmux：按Crtl + b 再按 hjkl 任意，例如向下切换则Crtl + b，然后按j，便可向下切换tmux

### 8.更加强大的终端zsh和on-my-zsh管理，支持主题和插件
### 9.vim支持Latex保存自动编译，编译实时显示（Windows Vim Latex Live Preview）
- 编译latex：```,lc```
- 查看latex：```,lv```
- 删除latex相关缓存文件：```,lr```
![vim-latex-preview](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/vim/vim-latex-preview.57of35zszoc0.png)

## 效果预览
![Image text](img/preview.gif)

# Vim or Neovim
## Ubuntu安装方式
```bash
# 可在内部选择对应的版本
git clone https://github.com/SivanLaai/vimrc.git
cd vimrc
./install.sh
#TODO: 安装完成记得进入vim更新插件
```

# vim-gui
## windows
#### 1.下载安装vim-gui
- gVim
[下载python编译版本gvim](https://github.com/vim/vim-win32-installer/releases/latest)
- Neovim
[下载python编译版本neovim](https://github.com/neovim/neovim/releases)
配置路径```D:\Program Files\Neovim\bin```为系统环境变量

#### 2.安装对应版本的Python
- GVim查看对应版本的Python
[查看相关版本的python下载安装：](https://github.com/vim/vim-win32-installer/releases/latest)
 ![python](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/vim/python.2aejfb0v8g7w.png)
- [下载Python](https://www.python.org/downloads/)

#### 3.安装字体
- [下载字体 DejaVu Sans Mono for Powerline](https://github.com/powerline/fonts/blob/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf)

#### 4.安装universal-ctags/pygments 和 gtags
##### （1）universal-ctags
- [下载universal-ctags](https://github.com/universal-ctags/ctags-win32/releases)
- 将ctags拷贝到安装路径，如```D:\Program Files\ctags```
- 配置路径```D:\Program Files\ctags```为系统环境变量
##### （2）pygments（主要作用是配合ctags来查找引用）
```
pip install pygments
```
##### （3）gtags
- [下载gtags](http://adoxa.altervista.org/global/dl.php?f=win32)
- 将gtags拷贝到安装路径，如```D:\Program Files\gtags```
- 配置路径```D:\Program Files\gtags```为系统环境变量

#### 5.安装ripgrep
- [下载ripgrep](https://github.com/BurntSushi/ripgrep/releases/latest)
- 将ripgrep程序拷贝到安装路径，如```D:\Program Files\ripgrep```
- 配置路径```D:\Program Files\ripgrep```为系统环境变量
#### 6.安装Latex
- [下载miktex](https://miktex.org/download)
- 安装mitex并更新
#### 7.安装Okular
- [下载Okular](https://binary-factory.kde.org/job/Okular_Nightly_win64/)
- 将Okular程序安装到路径，如```D:\Program Files\Okular```
- 配置路径```D:\Program Files\Okular```为系统环境变量
#### 8.安装MSYS2
- [下载MSYS2](https://www.msys2.org/)
- 将MSYS2程序安装到路径，如```D:\Program Files\MSYS2```
- 配置路径```D:\Program Files\MSYS2\usr\bin```为系统环境变量
- 配置路径```D:\Program Files\MSYS2\clang4\bin```为系统环境变量
- 安装clang64
```bash
# 更新软件库
pacman -Syu
# 更新核心软件
pacman -Su
# 安装Clang64编译环境
pacman -S --needed base-devel mingw-w64-clang-x86_64-toolchain
```
- [下载git](https://github.com/git-for-windows/git/releases/tag/v2.33.0.windows.2)
- 将git程序安装到路径，如```D:\Program Files\git```
- 配置路径```D:\Program Files\git\bin```为系统环境变量
- git中文显示错误修正
```bash
git config --global core.quotepath false
```
- 想卸载某个包的话
```bash
pacman -Rs mingw-w64-clang-x86_64-toolchain
```
#### 9.配置vim-format依赖
```zsh
#C++ 通过Clang64已经成功支持
#Python
pip install --upgrade autopep8
#html\css\js
npm install -g js-beautify
```
#### 10.复制配置文件
- gVim
```zsh
cp -rf gvim/_vimrc $vim/_vimrc
cp -rf gvim/autoload vimfile
- NeoVim-qt
cp -rf neovim-qt/* ~/AppData/Local/nvim
# Solarized Dark 主题复制
cp -rf gvim/colors vimfile
```
#### 11.配置vim-gui
```zsh
:PlugInstall #待安装完成
```
## Xshell 护眼主题 Eyes Protection
### 安装方式
- 在Xshell 配色方案里导入 本项目中的xcs文件

### 界面预览
#### Solarized Dark

![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/vim/Solarized_Dark.3nb6a0yfdwk0.jpg)

#### Solarized Light

![Image text](https://cdn.jsdelivr.net/gh/SivanLaai/image-store-rep@master/vim/Solarized_Light.70z8wbs2y1c0.png)
