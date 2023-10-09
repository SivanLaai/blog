---
title: 强化学习笔记
date: 2023-10-09T15:28:15+08:00
draft: true
categories:
  - 强化学习
tags:
---
# 贝尔曼公式

## state value定义

State value可以理解成状态值，他的含义是从当前的某一个状态出发所得到的所有的return的期望。
假设存在一个这样的回合.
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009153555.png)

其中$G_t$表示的是这一趟回合，所有的步骤的reward之和，也可以用return表示。
因为有可能会出现多种不同的回合（可以理解成解法），所以在某个状态$s$下对$G_t$求期望就可以表示成状态值$\nu_{\pi}(s)$
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009154050.png)

![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009154124.png)

![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009155204.png)
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009155212.png)
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009155228.png)

## Action value行动值定义
表示在某个动作$a$和状态$s$下，对所有的回合期望的回报值。其定义如下：
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009155521.png)
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231009155538.png)

动作值可以用来衡量一个动作的好坏，用来决策在某个状态下采取哪个动作，一般是会选择期望值最大的动作。