# pytorch使用问题

## 1.ModuleNotFoundError: No module named '_lzma'
### Ubuntu
#### （1）安装依赖
```bash
apt-get install liblzma-dev -y
pip install backports.lzma
```
#### （2）打开```lzma.py```
```bash
vim ~/a/b/python3.7/lzma.py
```
#### （3）修改代码
```bash
#修改前
from _lzma import *
from _lzma import _encode_filter_properties, _decode_filter_properties

#修改后
try:
    from _lzma import *
    from _lzma import _encode_filter_properties, _decode_filter_properties
except ImportError:
    from backports.lzma import *
    from backports.lzma import _encode_filter_properties, _decode_filter_properties
```


---

> 作者: [SivanLaai](https://www.sivanlaai.top)  
> URL: https://www.sivanlaai.top/posts/technology/pytorch/  

