---
title: Dreamplace
draft: true
password: 1233
date: 2023-03-27T16:32:20+08:00
draft: true
categories:
  - 笔记
---

# 变量说明

num_filler_nodes:  待填充节点的个数，filler cell是一些不存在的节点，用来填充初始区域的节点。

filler的总数=standard cell 的总数 + 可移动组件的 总数

cells_pos = x[:num_nodes] + y[:num_nodes]，
num_nodes = num_movable_cells + num_macro_cells + num_filler_cells
num_physical_nodes = num_movable_cells + num_macro_cells

**Fence**
Fence是Floorplan中作用于module或者instance group的一种约束。在Innovus中，当你希望某个模块里面的instance放在某个特定的区域的话，我们就可以给module或者instance group添加约束，约束可以分为四种：按照约束由强到弱，可以分为是Fence，Region，Guide，SoftGuide。

regions，一维坐标，像围栏和

一些变量的说明
![image.png](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230403100641.png)

## 线长平滑函数LPABSWL网表梯度

对于某个网表e，该网表有n个节点，$i\leq i < j \leq n$和$j - i + 1 > 2$ ，在该网表上其梯度为$g(x,p)=\lbrack \frac{\partial f(x,p)}{\partial x_1},\dots, \frac{\partial f(x,p)}{\partial x_n}\rbrack$，对于任意点l有如下求导公式：

$$ \frac{\partial f_{i,j}(x,p)}{\partial x_l}= \frac{\partial f_{i,k}(x,p)}{\partial f_{i,k}}\frac{\partial f_{i,k}(x,p)}{\partial x_l} + \frac{\partial f_{k+1,j}(x,p)}{\partial f_{k+1,j}}\frac{\partial f_{k+1,j}(x,p)}{\partial x_l}$$
