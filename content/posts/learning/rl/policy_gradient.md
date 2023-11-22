---
title: 强化学习策略梯度
date: 2023-11-22T16:14:17+08:00
draft: true
categories: 
tags:
---
![image.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231122161506.png)

# Value Update
这里使用了蒙特卡罗来估计q值，因为没有模型，这个模型如果换成了神经网络就变成了Actor-Critic
# Policy Update
更新策略，这个算法策略分布只有一个所以是on policy的
# 代码
```python
import numpy as np

np.random.seed(1)

import torch.nn as nn
import torch.nn.functional as F
import torch
from torch import optim
from torch import Tensor

device = torch.device("cuda" if torch.cuda.is_available else "cpu")

class SoftCrossEntryopy(nn.CrossEntropyLoss):
    def __init__(self, weight: Tensor = None, size_average=None, ignore_index: int = -100,
             reduce=None, reduction: str = 'mean', label_smoothing: float = 0.0) -> None:
        super().__init__(weight, size_average, reduce, reduction)
    def forward(self, input: Tensor, target: Tensor) -> Tensor:
        output = torch.mean(torch.sum(-torch.log(input)*target, 1))
        return output

class NNet(nn.Module):
    def __init__(self, 
                 n_actions,
                 n_features,
                 hidden_size=10,
                 ):
        super().__init__()
        self.fc1 = nn.Linear(n_features, hidden_size)
        self.fc1.weight.data.normal_(0, 0.3)   # initialization
        self.fc1.bias.data.normal_(0.1)   # initialization

        self.fc2 = nn.Linear(hidden_size, n_actions)
        self.fc2.weight.data.normal_(0, 0.3)   # initialization
        self.fc2.bias.data.normal_(0.1)   # initialization

    def forward(self, x):
        x = self.fc1(x)
        x = F.relu(x)
        x = self.fc2(x)
        x = F.softmax(x) # action probs
        return x

class PolicyGradient:
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

        self.ep_obs, self.ep_as, self.ep_rs = [], [], []

        self.policyNet = NNet(n_actions, n_features).to(dtype=torch.double)

    def choose_action(self, observation):
        s = torch.DoubleTensor(observation[np.newaxis, :])
        prob_weights = self.policyNet(s).detach().numpy()
        action = np.random.choice(range(prob_weights.shape[1]), p=prob_weights.ravel())  # select action w.r.t the actions prob
        return action

    def store_transition(self, s, a, r):
        self.ep_obs.append(s)
        self.ep_as.append(a)
        self.ep_rs.append(r)

    def learn(self):
        # update value
        q = torch.DoubleTensor(self.getQValueByMonteCarlo()).view(-1, 1)

        # update policy
        s =  torch.DoubleTensor(np.vstack(self.ep_obs))
        a = torch.LongTensor(self.ep_as).view(-1, 1)
        optimizer = optim.Adam(self.policyNet.parameters(), lr=self.lr)
        optimizer.zero_grad()

        criterion = SoftCrossEntryopy()

        #action_softmax_probs = self.policyNet(s).max(1)[0].view(-1, 1)  # shape (batch, 1)
        action_softmax_probs = self.policyNet(s).gather(1, a)  # shape (batch, 1)
        
        loss = criterion(action_softmax_probs, q)

        # print(loss.item())

        loss.backward()

        optimizer.step()

        #self.train_step_counter += 1

        #return loss.item()

        self.ep_obs, self.ep_as, self.ep_rs = [], [], []    # empty episode data
        return q

    def getQValueByMonteCarlo(self):
        # discount episode rewards
        discounted_ep_rs = np.zeros_like(self.ep_rs)
        running_add = 0
        for t in reversed(range(0, len(self.ep_rs))):
            running_add = running_add * self.gamma + self.ep_rs[t]
            discounted_ep_rs[t] = running_add

        # normalize episode rewards
        discounted_ep_rs -= np.mean(discounted_ep_rs)
        discounted_ep_rs /= np.std(discounted_ep_rs)
        return discounted_ep_rs


import gym
import matplotlib.pyplot as plt

DISPLAY_REWARD_THRESHOLD = 400  # renders environment if total episode reward is greater then this threshold
RENDER = False  # rendering wastes time

env = gym.make('CartPole-v0')
env.seed(1)     # reproducible, general Policy gradient has high variance
env = env.unwrapped

print(env.action_space)
print(env.observation_space)
print(env.observation_space.high)
print(env.observation_space.low)

RL = PolicyGradient(
    n_actions=env.action_space.n,
    n_features=env.observation_space.shape[0],
    learning_rate=0.02,
    reward_decay=0.99,
    # output_graph=True,
)

for i_episode in range(3000):

    observation = env.reset()

    while True:
        if RENDER: env.render()

        action = RL.choose_action(observation)

        observation_, reward, done, info = env.step(action)

        RL.store_transition(observation, action, reward)

        if done:
            ep_rs_sum = sum(RL.ep_rs)

            if 'running_reward' not in globals():
                running_reward = ep_rs_sum
            else:
                running_reward = running_reward * 0.99 + ep_rs_sum * 0.01
            if running_reward > DISPLAY_REWARD_THRESHOLD: RENDER = True     # rendering
            print("episode:", i_episode, "  reward:", int(running_reward))

            vt = RL.learn()

            if i_episode == 0:
                plt.plot(vt)    # plot the episode vt
                plt.xlabel('episode steps')
                plt.ylabel('normalized state-action value')
                plt.show()
            break

        observation = observation_
```