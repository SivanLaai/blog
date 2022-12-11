---
title: Rime更新历史
date: 2021-07-29 14:11:51
categories:
  - 项目
tags:
  - rime
---
## 更新历史

#### 2021-08-01

 - 1.修复九宫拼音不支持简拼的情况，如输入xqw不显示结果。
 - 2.四叶草拼音去除25258个重复的词组，只保留最高频次的词组
 ```
 ./Clover四叶草拼音/clover.phrase.dict.yaml:成事在人     cheng shi zai ren       22846
 ./Clover四叶草拼音/THUOCL_chengyu.dict.yaml:成事在人    cheng shi zai ren       21
 如上所示，成事在人，在两个字典中都有频次，只保留clover.phrase.dict.yaml中22846频次的词组
 ```
 - 3.更新四叶草拼音拼音错误，例如反弹拼音为fandan，[错误修复来源@wisim](https://github.com/fkxxyz/rime-cloverpinyin/pull/85)，感谢@[spphinslove](https://github.com/SivanLaai/rime_pure/issues/32)的反馈
 - 4.四叶草拼音-汉字帧-拼音错误修改，把帧错误拼音zheng相关的词组全部修改为帧zhen
 - 修改费时费力，不易，请大家多多支持，[点击支持](https://github.com/SivanLaai/rime_pure#sparkling_heart%E6%94%AF%E6%8C%81%E8%BF%99%E4%B8%AA%E9%A1%B9%E7%9B%AE)。

#### 2021-07-29

 - 1.添加九宫格支持隐藏
 - 2.添加常用功能说明

#### 2021-06-27

- 1.更新同文3.2.0支持
- 2.修复小鹤双拼简繁转换问题
- 3.自然码支持简繁转换问题

**注：简繁转换属于opencc的内容，和同文没有关系，odc2文件是opencc的生成结果。**

#### 2021-06-23

- 1.增加自然码双拼，没有辅助码
![Image text](/img/rime-pure/double.png)

#### 2021-06-03

- 1.修正郑码字典显示错误https://github.com/SivanLaai/rime_pure/issues/25
- 2.默认所有方案不显示字符和表情包

#### 2021-02-07

- 1.增加qq五笔
- 2.增加笔画输入@[HarryWang29](https://github.com/HarryWang29)
- 3.增加九宫格双拼

#### 2020-12-17

- 1.修正拼音自定义添加造词的功能

#### 2020-12-5（更新，增加徐码、郑码，支持拼音和五笔反查，增加全键盘的符号键盘）
- 1.优化小鹤双拼方案，双拼支持拼音“`”反查小鹤双拼编码
>
![Image text](/img/rime-pure/flypy_fancha.png)
- 2.增加徐码
>
![Image text](/img/rime-pure/xuma.png)
- 3.徐码支持五笔“`”反查编码
>
![Image text](/img/rime-pure/xuma_wubi.png)
- 4.徐码支持拼音“`”反查编码
> 
![Image text](/img/rime-pure/xuma_pinyin.png)
- 5.增加郑码
>
![Image text](/img/rime-pure/zhengma.png)
- 6.郑码支持拼音“`”反查编码
>
![Image text](/img/rime-pure/zhengma_fancha.png)
- 7.手机同文，全键盘的符号键盘，调整回车键大小，调整符号键大小，更符合手机端操作
>
![Image text](/img/rime-pure/trime_symbol.jpg)

#### 2020-10-31
- 1.新增双拼输入方案支持-小鹤双拼
>
![Image text](/img/rime-pure/xiaohe.png)
- 2.所有输入方案配置支持繁简转换、中英转换、字符输入、emoji表情、全半角转换
- 3.调整键盘布局，超大空格，减少误触
- 4.增加同文优化版皮肤


#### 2020-10-27
- 1.新增讯飞皮肤
- 2.更新部分细节
- 3.增加小鹤九宫双拼

#### 2020-10-25
- 1.去除了明月拼音，添加了以搜狗为基础的输入方案——🍀️四叶草简体拼音
- 2.以🍀️四叶草简体拼音为基础，添加了四叶草九宫输入方案，方便在手机端可以使用
- 3.同文手机端添加了两款机械键盘主题，cherry机械键盘/罗技
- 4.四叶草拼音输入法在手机端支持简繁转有一些问题，原因是没有正确配置opencc，修改后手机端支持简繁转换
- 5.极品五笔方案增加支持字符（输入`平方`可以选择`²`），emoji表情，繁简转换
- 6.支持五笔反查
>
![Image text](/img/rime-pure/wubireverse.png)
