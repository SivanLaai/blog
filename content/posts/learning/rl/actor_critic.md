---
title: 强化学习A2C算法解析与实现
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

# 概念解释
## 批评家Critic

批评家不作什么动作，而是对演员的动作进行打分。

学习一个状态函数，看到一个状态s的时候累加函数的奖励值。

## 演员Actor

演员根据评论家的打分进行修正自己作动作的决策

学习一个策略函数，根据状态s选择下一步的动作。

## 算法流程

# 算法Python实现和解释

### 前置需求
- 安装numpy
- 安装torch cuda版本
- 强化学习gym环境
### 导入必要的包
```python
import numpy as np

# reproducible
np.random.seed(1)

import torch.nn as nn
import torch.nn.functional as F
import torch
from torch import optim
from torch import Tensor
# 定义需要的包
device = torch.device("cuda" if torch.cuda.is_available else "cpu")
```
### 实现对数熵
```python
class SoftCrossEntryopy(nn.CrossEntropyLoss):
    def __init__(self, weight: Tensor = None, size_average=None, ignore_index: int = -100,
             reduce=None, reduction: str = 'mean', label_smoothing: float = 0.0) -> None:
        super().__init__(weight, size_average, reduce, reduction)
    def forward(self, input: Tensor, target: Tensor) -> Tensor:
        output = torch.mean(torch.sum(-torch.log(input)*target))
        return output
```

```python
class Critic(nn.Module):
    def __init__(self, 
                 n_features,
                 hidden_size=512,
                 ):
        super().__init__()
        self.fc1 = nn.Linear(n_features, hidden_size)
        self.fc1.weight.data.normal_(0, 0.3)   # initialization
        self.fc1.bias.data.normal_(0.1)   # initialization
        self.ln = nn.LayerNorm(hidden_size)

        self.fc2 = nn.Linear(hidden_size, 1)
        self.fc2.weight.data.normal_(0, 0.3)   # initialization
        self.fc2.bias.data.normal_(0.1)   # initialization

    def forward(self, x):
        x = self.fc1(x)
        x = self.ln(x)
        x = F.relu(x)
        #x = self.ln(x)
        x = self.fc2(x)
        return x
```

```python
class Actor(nn.Module):
    def __init__(self, 
                 n_actions,
                 n_features,
                 hidden_size=512,
                 ):
        super().__init__()
        self.fc1 = nn.Linear(n_features, hidden_size)
        self.fc1.weight.data.normal_(0, 0.3)   # initialization
        self.fc1.bias.data.normal_(0.1)   # initialization
        self.ln = nn.LayerNorm(hidden_size)

        self.fc2 = nn.Linear(hidden_size, n_actions)
        self.fc2.weight.data.normal_(0, 0.3)   # initialization
        self.fc2.bias.data.normal_(0.1)   # initialization


    def forward(self, x):
        x = self.fc1(x)
        x = self.ln(x)
        x = F.relu(x)
        x = self.fc2(x)
        x = F.softmax(x) # action probs
        return x
```

```python
class AdvancedActorCritic:
    def __init__(
            self,
            n_actions,
            n_features,
            learning_rate=0.01,
            reward_decay=0.95,
            output_graph=False,
    ):
        self.n_actions = n_actions
        self.n_features = n_features
        self.lr = learning_rate
        self.gamma = reward_decay
        self.ep_rs = list()

        self.actorNet = Actor(n_actions, n_features).to(dtype=torch.double)
        self.criticNet = Critic(n_features).to(dtype=torch.double)

    def choose_action(self, observation):
        s = torch.DoubleTensor(observation[np.newaxis, :])
        prob_weights = self.actorNet(s).detach()
        action = np.random.choice(range(prob_weights.shape[1]), p=prob_weights.ravel())  # select action w.r.t the actions prob
        return action

    def store_r(self, r):
        self.ep_rs.append(r)

    def clear_r(self):
        self.ep_rs = list()

    def critic_learn(self, s, s_, r_):
        critic_optimizer = optim.Adam(self.criticNet.parameters(), lr=self.lr)
        critic_optimizer.zero_grad()

        v_ = self.criticNet(s_).detach()

        v = self.criticNet(s)

        r_target = r_ + self.gamma*v_

        
        critic_lossfn = nn.MSELoss()
        critic_loss = critic_lossfn(r_target, v)

        critic_loss.backward()

        critic_optimizer.step()

        td_error = r_target - v

        return td_error.detach()

    def actor_learn(self, s, a, td_error):
        actor_optimizer = optim.Adam(self.actorNet.parameters(), lr=self.lr)
        actor_optimizer.zero_grad()

        action_softmax_probs = self.actorNet(s)
        # print(action_softmax_probs)
        action_softmax_probs = action_softmax_probs.gather(1, a)  # shape (batch, 1)
        # print(np.shape(action_softmax_probs))

        # print(np.shape(td_error.detach()))
        
        actor_lossfn = SoftCrossEntryopy()
        actor_loss = actor_lossfn(action_softmax_probs, td_error)#td_error.detach())

        actor_loss.backward()

        actor_optimizer.step()

    def learn(self, s, s_, r_, a):

        s =  torch.DoubleTensor([s])
        s_ =  torch.DoubleTensor([s_])
        a = torch.LongTensor([[a]])
        r_ = torch.DoubleTensor([[r_]])

        # critic value update
        td_error = self.critic_learn(s, s_, r_)
        # update policy
        self.actor_learn(s, a, td_error)
        

```

```python
import gym
import matplotlib.pyplot as plt

DISPLAY_REWARD_THRESHOLD = 50  
RENDER = False 

env = gym.make('CartPole-v0')
env.seed(1) 
env = env.unwrapped

print(env.action_space)
print(env.observation_space)
print(env.observation_space.high)
print(env.observation_space.low)

RL = AdvancedActorCritic(
    n_actions=env.action_space.n,
    n_features=env.observation_space.shape[0],
    learning_rate=0.02,
    reward_decay=0.99,
)

for i_episode in range(3000):

    s = env.reset()

    while True:
        if RENDER: env.render()

        a = RL.choose_action(s)

        s_, r_, done, info = env.step(a)

        RL.store_r(r_)
        RL.learn(s, s_, r_, a)

        if done:
            ep_rs_sum = sum(RL.ep_rs)
            if 'running_reward' not in globals():
                running_reward = ep_rs_sum
            else:
                running_reward = running_reward * 0.99 + ep_rs_sum * 0.01
            if running_reward > DISPLAY_REWARD_THRESHOLD: RENDER = True     # rendering
            print("episode:", i_episode, "  reward:", int(running_reward))

            RL.clear_r()
            break

        s = s_
```