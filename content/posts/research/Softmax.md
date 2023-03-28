---
title: Softmax 梯度下降优化
categories:
  - 笔记
tags:
  - Softmax
date: 2018-04-20 13:21:00
---
## softmax函数简介：
&emsp;&emsp; softmax函数是用来处理多分类的一种软性分类器，它输出的是每个类别的概率值。数据集特征矩阵为X其维度为D+1 x N（其中D+1为原本样本的特征维度数D加上bias的维度后的维度数，所以为D+1，N为样本数），标注矩阵为Y，维度为C x N(其中C为类别数，N为样本数)。
![image](/images/1524209707955.png)
&emsp;&emsp; 当我们给softmax输入一个样本Xi其输出格式为softmax(Xi) = [s1,s2,......,sC]，其中s1对应类别1的概率值，s2对应类别2的概率值，依次类推到sC。softmax的过程如下:
![image](/images/1524203488388.png)
然后来衡量第i个样本的loss公式如下：
![image](/images/1524205811631.png)（其中yi表示第i个样本对应的类别）
所以N个样本的loss为：
![image](/images/1524205761034.png)
加上正则化后为：
![image](/images/1524449673188.png)
由如下Z和W与X的关系：
![image](/images/1524368247375.png)

则可以把loss函数化成全部关于w的函数为：
![image](/images/1524450300358.png)
现在我们来求softmax的导数，现在我们先对一个样本的导数进行求解，先把Li化简为如下形式：
![image](/images/1524206564344.png)
则当对Wyi求导的时候（j==yi）：
![image](/images/1524206933385.png)
当对Wj求导的时候（j！=yi）
![image](/images/1524206992830.png)
则如上操作可以求出单个loss的梯度如下(其中设yi=2)：
![image](/images/1524207290063.png)
现在我们需要把所有的梯度求出来并做一个平均就得到了loss的平均梯度：
![image](/images/1524207442115.png)
加上正则化后的loss函数：
![image](/images/1524207513644.png)
然后在足够的迭代次数中用梯度更新W（其中α为学习率）：
![image](/images/1524207624590.png)
直到在达到足够的迭代次数或者loss足够小的时候则停止更新
此时得到的W则为我们在这个softmax中所得到的W，然后在测试集中测试所有样本可得到样本的预测类别。