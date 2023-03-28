---
title: 全连接神经网络
categories:
  - 笔记
tags:
  - 神经网络
date: 2018-04-22 20:14:00
---
&emsp;&emsp; 再学完斯坦福大学的计算机视觉的课后，总结一下自己对全连接神经网络的理解，方便在以后自己可以查阅和复习。首先简单的复习一下神经网络的概念，神经网络有输入层、隐藏层和输出层三种层，其中隐藏层可能会有多层，一个神经网络有多少层要看有多少个隐藏层加上输出层就为该神经网络的层数。神经网络的来源源于生物体的大脑的神经元的触发机制，但是我们要区分神经网络和真实生物体的差别。神经网络不是生物体神经元的真实映射。本篇文章以cs231n中的作业二中的神经网络作为背景进行讲述。
## 1.神经网络中的基本结构
![image](/images/neuralnetwork.png)
&emsp;&emsp; 如上图所示，神经网络有输入层、隐藏层和输出层组成，这个神经网络一共有两层，一个隐藏层和一个输出层，输入层不算层数。输入层有输入维度为3，第一层有四个神经元，输出层有两个神经元。在某些结构中，我们的神经网络结构会更加，隐藏层可能会不只一个，而且每一层的神经元个数也会不唯一。其中每一个神经元有一个输入和一个输出，如下为一个神经元的内部详解：
![image](/images/activate.png)
一个神经元其实有两个处理，首先是对前面的输入做一个线性求和$$Z = \sum_{i=1}^{N} wi \cdot xi +b$$
然后在有一个激活函数f在对z做处理得到这个神经元的输出
$$f(\sum_{i=1}^{N} wi \cdot xi +b)$$
讲完了基本的神经网络结构后，我们现在以cs231n中作业2中的全连接神经网络架构做一个讲述，他的架构为{affine - [batch norm] - relu - [dropout]} x (L - 1) - affine - softmax也就是说前面的L-1层的每一层，先做一个affine，然后batch norm 在接着激活函数用relu处理一下输出，最后做一个dropout，到最后一层就在一个affine后进入一个softmax层得到神经网络的最终输出。
## 2.前向传播
&emsp;&emsp; 前向传播是从输入层开始把每一层的输出递交给下一层直至最后一层将结果输出的过程，在cs231n中前面的L-1层的前向过程如下：
affine层对输入做一个线性组合输出affOut：
$$affOut = \sum_{i=1}^{N} wi \cdot xi +b$$
batch norm层：
![image](/images/batchnorm.png)
得到输出batchOUt
relu层：
![image](/images/relu.png)
得到输出reluOut
dropout层：
![image](/images/dropout.png)
得到输出dropOut
&emsp;&emsp; 然后在第L层也就是最后一层先进入一个affine层，然后把结果进入一个softmax层得到各个类别的分类概率。
在对每个样本softmax进行求loss得到最后的softmax loss，在加上正则化后为
$$L=\frac{1}{N}\sum_{i=1}^{N}Li(W) + \lambda \cdot \sum_{l} \sum_{i}\sum_{j}W_{ij}^{l}$$
``` python
#代码解释
affOut,affCache = affine_forward(inputX, W, b)
batchOut,batchCache = batchnorm_forward(affOut, gamma, beta, self.bn_params[i])
reluOut,reluCache = relu_forward(batchOut)
dropOut,dropCache = dropout_forward(reluOut, self.dropout_param)
```
## 3.反向传播
&emsp;&emsp; 反向传播其实就是链式求导的一个应用，求loss函数对最后一层输入的求导为：
$$dZL = \frac{dL}{dZ} = \frac{1}{N}\sum_{N}^{i=1}\frac{dLi}{dZi}$$
到dropOut层反向传播（该层输入 reluOut， 输出 dropOut（当为L-1层的时候dropOut=ZL））：
$$\frac{dL}{dreluOut} = \frac{dL}{ddropOut} \cdot \frac{ddropOut}{dreluOut}$$
到relu层反向传播（该层输入 dbatchOut 输出 reluOut）：
$$\frac{dL}{dbatchOut} = \frac{dL}{dreluOut} \cdot \frac{dreluOut}{dbatchOut}$$
到batchout层（该层输入 affOut， 输出 batchOut）：
$$\frac{dL}{daffOut} = \frac{dL}{dbatchOut} \cdot \frac{dbatchOut}{daffOut}$$
$$d\gamma = \frac{dL}{d\gamma} = \frac{dL}{dbatchOut} \cdot \frac{dbatchOut}{daffOut}$$
$$d\beta = \frac{dL}{d\beta} = \frac{dL}{dbatchOut} \cdot \frac{dbatchOut}{daffOut}$$
到affine层（该层输入 X， 输出 affOut）：
$$dX = \frac{dL}{dX} = \frac{dL}{daffOut} \cdot \frac{daffOut}{dX}$$
$$dW = \frac{dL}{dW} = \frac{dL}{daffOut} \cdot \frac{daffOut}{dW}$$
$$db = \frac{dL}{db} = \frac{dL}{daffOut} \cdot \frac{daffOut}{db}$$
## 4.权重初始化
![image](/images/neuralnetwork.png)
&emsp;&emsp; 继续拿这个神经网络来说明，在第一层和第二层中我们都需要对权重进行初始化，每一层的w的维度初始化为本层的输入个数和本层的神经元个数，例如上图中第一层w的维度为3x4的矩阵，b的维度为1x4，第二层权重w的维度为4x2，b的维度为1x2。batchnorm层中beta和gamma的维度都为1xD（D为该层神经元的个数）。
&emsp;&emsp; 一般w为从高斯分布中均值为0进行初始化，b初始化为0矩阵，beta初始化为0，gamma初始化为1
## 5.神经网络中的梯度下降
对每一层：
$$\gamma = \gamma - \alpha \cdot d\gamma$$
$$\beta = \beta - \alpha \cdot d\beta$$
$$W = W - \alpha \cdot dW$$
$$b = b - \alpha \cdot db$$
&emsp;&emsp; 然后前向传播求出loss，当loss足够小或者迭代次数足够多的时候停止梯度下降，此时参数即为近似最优解
