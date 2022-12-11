---
title: python总结
date: 2021-09-16 16:05:50
permalink: /pages/0744be/
categories:
  - 问题总结
tags:
  - 踩坑
  - python
---
## Python 相关问题
### Python ImportError: No module named _bz2
```bash
sudo apt-get install libbz2-dev
#重新编译Python
```
### ImportError: Missing optional dependency 'openpyxl'
```bash
pip install openpyxl
#重新编译Python
```

###  重置linux的python

```bash
unset PYTHONHOME
unset PYTHONPATH
```

###  安装pip
- 下载get-pip.py
```bash
wget https://bootstrap.pypa.io/get-pip.py
```
- 安装pip
```bash
python get-pip.py
```
