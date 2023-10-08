---
title: Q学习算法
date: 2023-09-28T11:52:17+08:00
draft: false
categories:
  - 强化学习
tags:
---
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20230928170535.png)

状态$s_1,s_2$，动作$a_1,a_2$
当前步的实现：$$Q(s_1,a_2)=r+\gamma \max_{a^`}(Q(s^`,a^`))$$，其中$r$表示的是采取动作$a_2$到达状态$s^`$的奖励，所以当前步的现实是包含了对于下一步采取动作$a^`$的奖励估计，也包含了到达当前状态的奖励$r$。
当前步的估计：$$Q(s_1,a_2)$$
当前状态的估计和现实之前的误差为：$$r+\gamma \max_{a^`}(Q(s^`,a^`))-Q(s_1,a_2)$$
其中$\gamma$表示对未来奖励衰减参数，则更新对于$Q(s_1,a_2)$的估计：$$Q(s_1,a_2)=Q(s_1,a_2)+\alpha (r+\gamma \max_{a^`}(Q(s^`,a^`))-Q(s_1,a_2))$$
其中$\alpha$表示误差学习参数

用$Q(S_1)$来简化表示从状态$S_1$出发的现实奖励，有以下推论：$$Q(S_1)=r_2+\gamma Q(S_2)=r_2+\gamma(r_3+\gamma Q(S_3))$$
则有：$$Q(S_1)=r_2+\gamma r_3+\gamma^2 r_4+\gamma^3 r_5+\dots$$，则比较远的步骤能否学习和$\gamma$有关，$\gamma=1$则全部都能看到，为0则全部都看不到，正常情况在0到1之间。