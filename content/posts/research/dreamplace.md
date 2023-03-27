---
title: Dreamplace
draft: true
password: 1233
tag:
  - hide
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
