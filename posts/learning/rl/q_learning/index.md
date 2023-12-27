# Q学习算法


# on-policy version
![1700639584120.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/1700639584120.png)

# off-policy version
![1700639584120.png](https://cdn.statically.io/gh/SivanLaai/image-store-rep@master/note/20231122160253.png)

# 算法实现

#### Value update
需要使用behaviour进采行采样
每一个episode里面会对所有的样本行采样来计算$y_T$，这个是target网络计算来的值
### 
policy update
主网络每次采样完成后进行参数更新，并达到一定次数后更新target网络的参数

## 代码
```python
import torch

import torch.nn as nn

import torch.nn.functional as F

  

device = torch.device("cuda" if torch.cuda.is_available else "cpu")

  

class NNet(nn.Module):

    def __init__(self,

                 n_actions,

                 n_features,

                 hidden_size=10,

                 ):

        super().__init__()

        self.fc1 = nn.Linear(n_features, hidden_size)

        self.fc1.weight.data.normal_(0, 0.3)   # initialization

        self.fc1.bias.data.normal_(0.1)   # initialization

  

        self.fc2 = nn.Linear(hidden_size, n_actions)

        self.fc2.weight.data.normal_(0, 0.3)   # initialization

        self.fc2.bias.data.normal_(0.1)   # initialization

  

    def forward(self, x):

        x = self.fc1(x)

        x = F.relu(x)

        return self.fc2(x)

  

from torch import optim

import numpy as np

  

class DeepQNetwork(object):

    def __init__(self,

                 n_actions,

                 n_features,

                 alpha=0.01,

                 reward_decay=0.9,

                 e_greedy=0.9,

                 hidden_size=10,

                 memory_size=500,

                 replace_iter=300,

                 e_greedy_increment=None

                 ):

        super().__init__()

        self.lr = alpha

        self.n_actions = n_actions

        self.n_features = n_features

        self.evalNet = NNet(n_actions=n_actions, n_features=n_features, hidden_size=hidden_size).to(dtype=torch.double)

        self.targetNet = NNet(n_actions=n_actions, n_features=n_features, hidden_size=hidden_size).to(dtype=torch.double)

  

        self.memory_size = memory_size

        self.replace_iter = replace_iter

        self.train_step_counter = 0

        self.gamma = reward_decay

        self.batch_size = 64

        self.epsilon_max = e_greedy

        self.epsilon = 0 if e_greedy_increment is not None else self.epsilon_max

  

        # initialize zero memory [s, a, r, s_]

        self.memory = np.zeros((self.memory_size, n_features * 2 + 2))

  

    def trainStep(self):

        if self.train_step_counter % self.replace_iter == 0:

            self.targetNet.load_state_dict(self.evalNet.state_dict())

            # print('\ntarget_params_replaced\n')

        # sample batch memory from all memory

        if self.memory_counter > self.memory_size:

            sample_index = np.random.choice(self.memory_size, size=self.batch_size)

        else:

            sample_index = np.random.choice(self.memory_counter, size=self.batch_size)

        #eval_optimizer = optim.SGD(self.evalNet.parameters(), lr=self.lr)

        eval_optimizer = optim.Adam(self.evalNet.parameters(), lr=self.lr)

  

        criterion = nn.MSELoss()

  

        eval_optimizer.zero_grad()

  

        # ------------------

        N_STATES = self.n_features

        b_memory = self.memory[sample_index, :]

        b_s = torch.DoubleTensor(b_memory[:, :N_STATES])

        b_a = torch.LongTensor(b_memory[:, N_STATES:N_STATES+1].astype(int))

        b_r = torch.DoubleTensor(b_memory[:, N_STATES+1:N_STATES+2])

        b_s_ = torch.DoubleTensor(b_memory[:, -N_STATES:])

  

        print(np.shape(b_a))

  

        # q_eval w.r.t the action in experience

        q_eval = self.evalNet(b_s).gather(1, b_a)  # shape (batch, 1)

        q_next = self.targetNet(b_s_).detach()     # detach from graph, don't backpropagate

        q_target = b_r + self.gamma * q_next.max(1)[0].view(self.batch_size, 1)   # shape (batch, 1)

        loss = criterion(q_eval, q_target)
  
        loss.backward()

        eval_optimizer.step()

        self.train_step_counter += 1

        return loss.item()

  

    def store_transition(self, s, a, r, s_):

        if not hasattr(self, 'memory_counter'):

            self.memory_counter = 0
  
        transition = np.hstack((s, [a, r], s_))

  
        index = self.memory_counter % self.memory_size

        self.memory[index, :] = transition

  

        self.memory_counter += 1

  

    def choose_action(self, observation):

        # to have batch dimension when feed into tf placeholder

        observation = observation[np.newaxis, :]

        observation = torch.tensor(observation, dtype=torch.double)

  

        if np.random.uniform() < self.epsilon:

            # forward feed the observation and get q value for every actions

            actions_value = self.evalNet(observation)

            action = np.argmax(actions_value.detach().numpy())

        else:

            action = np.random.randint(0, self.n_actions)

        return action
```




---

> 作者: [SivanLaai](https://blog.laais.cn)  
> URL: https://blog.laais.cn/posts/learning/rl/q_learning/  

