---
title: 多分类支持向量机
categories:
  - 笔记
tags:
  - 分类
date: 2018-06-28 10:39:00
---

多分类支持向量机可以用来处理多分类问题，其分类函数可以给每一个类得到一个分数值，从而从数值上了解哪个类别的分数高低，其损失函数也是通过某个特定的阈值来优化从而使得模型在正确类别上得到一个比其他类别更高的分数值。

#### loss函数(设定有C个类别)
$$s = [s_1, s_2, ..., s_C] = f(x_i, W) = [f(x_i, W)_1, f(x_i, W)_2, ... ,f(x_i, W)_C]$$
$$L_i = \sum_{j\neq y_i} \max(0, s_j - s_{y_i} + \Delta)$$
$$L =  \frac{1}{N} \sum_i L_i  +  \lambda R(W)$$
$$L = \frac{1}{N} \sum_i \sum_{j\neq y_i} \left[ \max(0, f(x_i; W)_j - f(x_i; W)_{y_i} + \Delta) \right] + \lambda \sum_k\sum_l W_{k,l}^2$$
#### 梯度下降 
$$s = W^Tx_i$$
$$j==yi时：\frac{dL_i}{dW_{y_i}} = -\sum_{j\neq y_i}\mathbb{I}(W^T_jx_i - W^T_{y_i}x_i + \Delta>0)$$
$$j！=i时：\frac{dL_i}{dW_yi} = \mathbb{I}(W^T_jx_i - W^T_{y_i}x_i + \Delta>0)$$
$$\frac{dL}{dW} = \frac{1}{N}\sum^N_{i=1}\frac{dL_i}{dW} + 2\lambda W$$
$$执行 W = W - \alpha \frac{dL}{dW},在根据W求s，然后求loss，最后优化得到较理想的W值$$