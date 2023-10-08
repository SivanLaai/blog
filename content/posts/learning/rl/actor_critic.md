---
title: 演员评论家算法
date: 2023-10-07T14:57:55+08:00
draft: true
categories:
  - 强化学习
tags:
---
## 策略Policy
### 增加Baseline

![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231008152433.png)

上面的式子表示的是梯度上升的更新方向使得整体的loss最大。
理想情况下，上面的三个动作abc都可以采样得到，其中c的奖励值最大，a的奖励次之，b的奖励值最小。因为所有的情况都采样到了，所以最后调整过后的概分率分布如图所示，a虽然选中的概率小，但是经过一轮采样后，概率变大了。

![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231008160027.png)

假设在采样过程当中，a从来都没有被采样过，b和c的概率在采样过后都会更新并增加，结果就是a这个动作选中的概率就会下降。

那要怎么样解决没采样概率下降的情况呢？

使用一个baseline来衡量R，式子如下 ：
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231008160525.png)

这样下来中间的值就会是有正有负了，这个b需要自己设置。

这样做的好处就是，大于b的Reward对应的动作概率就会增加，而小于b的Reward对应的动作就会减小，这就可以在一定程度上避免没有采样的概率变小。

## 批评家Critic

批评家不决定作什么动作，而是对演员的动作进行打分。

学习一个状态函数，看到一个状态s的时候累加函数的奖励值。
