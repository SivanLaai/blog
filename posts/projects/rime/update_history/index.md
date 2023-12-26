# Rime更新历史

## 更新历史


#### 2023-12-19
 - 升级 bigram 语言模型至先用 IDA 逆向分析，再编写 C 代码提取和转换为 Rime 格式的 [华宇拼音 v7](https://pinyin.thunisoft.com/index.html) 模型，同时优化语言模型的 bigram 频率和参数，提升输入法预测短语和句子的准确率。[@warm-ice0x00](https://github.com/warm-ice0x00)
#### 2023-05-09
 - 添加转换自 [华宇拼音 v6.9.1.183](http://srf.unispim.com/software/index.php) 的 bigram 语言模型，解决 Rime 缺乏符合简体中文语言习惯的语言模型的问题，提升预测短语和句子的准确性，从而提升输入效率。[@warm-ice0x00](https://github.com/warm-ice0x00)
 
#### 2022-12-30

 - 1.移除九宫模式下ascii模式的切换
 - 2.优化九宫数字键盘布局
 
 ![](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/ 20221230200634.png)


#### 2022-11-4

 - 1.优化四叶草拼音的基础词库为华宇输入法词库[@warm-ice0x00](https://github.com/warm-ice0x00)（不再使用原来的词库，原来的词库有很多问题。）

#### 2022-3-19

 - 1.调整剪切板功能快捷方式
 - 2.qq86五笔用户词添加不成功修复

#### 2021-10-26

 - 1.修复3.2.3所引入的键盘显示问题
 - 2.调整键盘的符号页面，详情查看同文功能页面
 - 3.调整数字页面为更加符合操作的九宫格数字页面
 - 4.输入键盘快速跳转符号剪切栏

#### 2021-10-20

 - 1.四叶草拼音的权重调整为最大概率保留，同时是以词组进行切割的，例如弹出如果是分词的话就是tanchu，不会再出现danchu的拼音，如果弹出不是一个完整的分词那拼音可能是按单个字保留拼音的最大概率。主要改动在[src/GenerateCloverData.py](./src/GenerateCloverData.py)。
 - 2.四叶草简体支持符号输入优化，/fh可以查看当前的符号，/jq可以查看所有的节气
 - 3.四叶草简体支持笔画反查（`后输入```hspnz```分别表示```一丨丿丶乙```）

#### 2021-10-17

 - 1.修复同文端繁简转换opencc资源文件为最新的ocd2，小狼毫端暂时不支持ocd2。

  

#### 2021-10-14

 - 1.同步更新同文官方支持的剪切板功能，可以查看剪切板和最近表情包历史，使用更为灵活的符号菜单。

  

#### 2021-09-01

 - 1.前前后后、零零碎碎一共花了十来天地时间完成基于四叶草词库的地球拼音输入方案。
![Image text](https://user-images.githubusercontent.com/33414148/131670446-5d9b6245-70cc-4ed0-8b6e-0667a56f06e7.png)

  

#### 2021-08-30

 - 1.四叶草支持多音字，最大程序的避免拼音错误，同时是以词组来分词的所以，不至于对所有的词组进行挨个多音字支持，而是优先词组。

    例如```弹出```分词后还是```弹出```，所以只有tan chu的拼音，如果分词为```弹\出```的话，则拼音会有tan chu 和 dan chu

 - 2.四叶草保留最大概率拼音词组，例如```是不```其中```不```为多音字，```不```的拼音有```bu```和```fou```，基于四叶草统计概率，```bu```的拼音概率更高，如果不是在词组的情况下，单字以```bu```为优先。

  

#### 2021-08-18

 - 1.写[爬虫exact-pinyin-mark](https://github.com/SivanLaai/exact-pinyin-mark)抓取[百度汉语](https://hanyu.baidu.com/)字典35W个组词数据用来精准匹配clover拼音数据。
 - 2.使用[luna拼音](https://github.com/rime/rime-luna-pinyin)修复clover拼音数据。
 - 3.使用[phrase-pinyin-data](https://github.com/mozillazg/phrase-pinyin-data)修复clover拼音数据。
 - 4.具有更高的基础词库，对于常见的拼音数据具有更高的识别率

  

#### 2021-08-11

 - 1.修复大字典中的的拼音错误。
 - 2.基于[python-pinyin](https://github.com/mozillazg/python-pinyin)对所有四叶草字典进行多音字修复，同时单字也支持多音字输入

 ```
 例如朝拼chao zhao zhu输入
 词频调整chao保留最高，依次递减10倍
 例如chao为123，zhao为12，zhu为1
 ```

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


---

> 作者: [SivanLaai](https://www.laais.cn)  
> URL: https://www.laais.cn/posts/projects/rime/update_history/  

