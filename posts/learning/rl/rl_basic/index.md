# 简介

# 概念
原先的动作是没有标签的，强化学习可以对每一个动作进行打分，然后学习，不断的迭代完成算法的学习。
## 按环境分类
### Model-Free RL（不理解所处环境）
环境给到什么就是什么，不理解环境是什么，这里的model表示的是环境，做出的动作完全独立于当前环境，反馈也只有在做出动作后才知道。
- Q Learning
- Sarsa
- Policy Gradients
### Model-Based RL（理解所处环境）
模型会对真实世界进行建模，通过过往的经验先理解真实世界是怎么样的，然后建立模拟反馈，让模拟世界尽量接近于真实的世界，可以作出最好的动作。

## 按Policy和Value分类

### 基于概念分类（Policy-Based RL）
根据当前的动作计算出下一步所有可能的动作的概率，下一步的每个动作都有可能选中。（可以处理连续的情况，输出一个概率分布）
- Q Learning
### 基于价值分类（Value-Based RL）
根据当前的动作计算出下一步所有可能的动作的值，选择价值最高的动作。（离散的，不能处理连续的情况）
- Sarsa
- Policy Gradients
### 基于概念和价值结合
- Actor-Critic
Actor做出动作，Critic对动作进行打分

## 按回合/单步分类

### 回合更新（蒙特卡罗更新）
等所有的步骤完成以后才更新
- Policy Gradients
- Monte-Carlo Learning
### 单步更新（蒙特卡罗更新）
等当前循环中的每个单步完成以后都可以进行更新
- 改进版Policy Gradients
- Sarsa
- Q Learning

## 按在线/离线分类
### 在线学习
只能是本人玩然后本人进行学习
- Sarsa
- Sarsa()
### 离线学习
可以学习别人怎么玩，看着别人怎么玩进行学习，边玩边学习，可以先记下来别人怎么玩，然后在过后在自己学习，学习和作动作可以分开执行
- Q Learning
- Deep Q Network


---

> 作者: [SivanLaai](https://www.laais.cn)  
> URL: https://www.laais.cn/posts/learning/rl/rl_basic/  

