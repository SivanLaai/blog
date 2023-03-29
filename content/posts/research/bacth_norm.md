---
title: 批量标准化
date: 2018-04-28 16:38:00
categories:
  - 笔记
tags:
  - 神经网络
---
## bacth normlization中的前向传播
input:X_{ij}(本层所有的样本矩阵为X维度为mxD，m为样本数，D为神经元的个数，其中X_{ij}为X中的某一个样本)
$$其中样本矩阵X = \begin{bmatrix}
 X_{11}& X_{12} & ... &X_{1D} \\\\ 
X_{21}& X_{22} & ... &X_{2D} \\\\ 
 .& . &  ...&. \\\\ 
 .&  .& ... & .\\\\ 
X_{m1}& X_{m2} & ... &X_{mD} 
\end{bmatrix},X_{i} = \begin{bmatrix}
 X_{i1}& X_{i2} & ... &X_{iD} \\\\ 
\end{bmatrix},第j列为X_{\cdot j} = \begin{bmatrix}
 X_{1j}\\\\ 
X_{2j}\\\\ 
 .\\\\ 
 .\\\\ 
X_{mj}
\end{bmatrix}$$
$$ output格式为: Yi = BN(X_{ij}, \gamma, \beta)\\\\ 
其中输出矩阵Y = \begin{bmatrix}
 Y_{11}& Y_{12} & ... &Y_{1D} \\\\ 
Y_{21}& Y_{22} & ... &Y_{2D} \\\\ 
 .& . &  ...&. \\\\ 
 .&  .& ... & .\\\\ 
Y_{m1}& Y_{m2} & ... &Y_{mD} 
\end{bmatrix}，m为样本数，D为输入维度数$$
前向传播过程如下
$$\mu_{j} = E(X) = \frac{1}{m}\sum_{i=1}^{m}X_{i}，则\mu_{j} 的维度为(1,D)\\\\
\sigma_{j}^{2} = Var(X) = \frac{1}{m}\sum_{i=1}^{m}(X_{i}-\mu_{j})^{2}，则\sigma_{j}^{2}的维度为(1,D)\\\\
对第i个样本的估计\hat{X_{ij}} = \frac{X_{ij} - \mu_{j}}{\sqrt{\sigma_{j}^{2} + \varepsilon }}，则\hat{X_{i}}维度为(1,D)\\\\
对m个样本估计\hat{X} = \frac{X - \mu_{j}}{\sqrt{\sigma_{j}^{2} + \varepsilon }}，则\hat{X}维度为(m,D)\\\\
第i个样本的输出Y_{i} = \gamma  \times \hat{X_{i}} + \beta，其中\gamma维度为(1,D),\beta维度为(1,D),则Y_{i}维度为(1,D)\\\\
则m个样本的输出Y = \gamma  \times \hat{X} + \beta，其中\gamma维度为(1,D),\beta维度为(1,D),则Y维度为(m,D)$$
## bacth normlization中的反向传播
$$假设上层梯度为\frac{dL}{dY}，本层输入为X，过程如下：\\\\
从X中选中第j列，令x = \begin{bmatrix}
 X_{1j}\\\\ 
X_{2j}\\\\ 
 .\\\\ 
 .\\\\ 
X_{mj}
\end{bmatrix}\\\\$$
#### (1)求dbeta
$$我们先求d\beta_{j} = \sum_{i=1}^{m}\frac{dL}{dY_{ij}} \cdot \frac{dY_{ij}}{d\beta_{j}}，
由Y_{i} = \gamma  \times \hat{X_{i}} + \beta可知Y_{ij} = \gamma_{j}  \times \hat{X_{ij}} + \beta_{j}，\frac{dY_{ij}}{d\beta_{j}}=1\\\\
所以d\beta_{j} = \sum_{i=1}^{m}\frac{dL}{dY_{ij}}，则对整个矩阵操作d\beta = \sum_{i=1}^{m}\frac{dL}{dY_{i}} = \begin{bmatrix}
 d\beta_{1}& d\beta_{2} & ... &d\beta_{D} \\\\ 
\end{bmatrix}$$
#### (2)求dgamma
$$
d\gamma_{j} = \sum_{i=1}^{m}\frac{dL}{dY_{ij}} \cdot \frac{dY_{ij}}{d\gamma_{j}}\\\\
由Y_{i} = \gamma  \times \hat{X_{i}} + \beta可知Y_{ij} = \gamma_{j}  \times \hat{X_{ij}} + \beta_{j}，\frac{dY_{ij}}{d\gamma_{j}}=\hat{X_{ij}}\\\\
所以d\gamma_{j} = \sum_{i=1}^{m}\frac{dL}{dY_{ij}} \cdot \hat{X_{ij}}\\\\
对整个矩阵进行操作d\gamma = \sum_{i=1}^{m}\frac{dL}{dY_{i}} \cdot \hat{X_{i}} = \begin{bmatrix} d\gamma_{1}& d\gamma_{2} & ... &d\gamma_{D} 
\end{bmatrix}$$
#### (3)求dX
最后我们还要对X进行求导，首先我们先看下面的链式路径：
![image](/images/chain_batchnorm.png)
$$对第i行第j列进行反向传播：\frac{dL}{dX_{ij}} = \sum_{k=1}^{m}\frac{dL}{d\hat{X_{kj}}} \cdot\frac{d\hat{X_{kj}}}{dX_{ij}} = \sum_{k=1}^{m} \sum_{l=1}^{m}(\frac{dL}{d\hat{Y_{lj}}} \cdot \frac{dY_{lj}}{d\hat{X_{kj}}})\cdot\frac{d\hat{X_{kj}}}{dX_{ij}}\\\\
由Y_{i} = \gamma  \times \hat{X_{i}} + \beta可知Y_{lj} = \gamma_{j}  \times \hat{X_{lj}} + \beta_{j}，则\frac{dY_{lj}}{d\hat{X_{kj}}}=\gamma_{j}(当l=k时)，\frac{dY_{lj}}{d\hat{X_{kj}}}=0(当l≠k时)\\\\
则\frac{dL}{dX_{ij}} = \sum_{k=1}^{m}\frac{dL}{dY_{kj}} \cdot \frac{dY_{kj}}{d\hat{X_{kj}}} \cdot\frac{d\hat{X_{kj}}}{dX_{ij}} = \sum_{k=1}^{m}\gamma_{j} \cdot \frac{dL}{dY_{kj}} \cdot\frac{d\hat{X_{kj}}}{dX_{ij}} \\\\
由\hat{X_{ij}} = \frac{X_{ij} - \mu_{j}}{\sqrt{\sigma_{j}^{2} + \varepsilon }}，\mu_{j} = \frac{1}{m}\sum_{k=1}^{m}X_{kj}，
\sigma_{j}^{2} = \frac{1}{m}\sum_{k=1}^{m}(X_{kj}-\mu_{j})^{2}和上图可知我们求\frac{d\hat{X_{ij}}}{dX_{ij}}的话有三条路径:\\\\ 
第一条路径为：\frac{d\hat{X_{kj}}}{dX_{ij}} = \left \lceil k==i \right \rfloor \cdot \frac{1}{\sqrt{\sigma_{j}^{2} + \varepsilon }}\\\\
第二条路径为：\frac{d\hat{X_{kj}}}{dX_{ij}} = \frac{d\hat{X_{kj}}}{d\mu_{j}} \cdot \frac{d\mu_{j}}{dX_{ij}}，\frac{d\hat{X_{kj}}}{d\mu_{j}} = -\frac{1}{\sqrt{\sigma_{j}^{2} + \varepsilon }},\frac{d\mu_{j}}{dX_{ij}} = \frac{1}{m}\\\\
则\frac{d\hat{X_{kj}}}{dX_{ij}} = -\frac{1}{m\sqrt{\sigma_{j}^{2} + \varepsilon }}\\\\
第三条路径为：\frac{d\hat{X_{kj}}}{dX_{ij}} = \frac{d\hat{X_{kj}}}{d\sigma_{j}^{2}} \cdot \frac{d\sigma_{j}^{2}}{dX_{ij}}，\\\\ 
\frac{d\hat{X_{kj}}}{d\sigma_{j}^{2}} = -\frac{X_{kj} - \mu_{j}}{2(\sigma_{j}^{2} + \varepsilon)^{\frac{3}{2}}}，\\\\
求解\frac{d\sigma_{j}^{2}}{dX_{ij}}有两个路径：
路径1：\frac{d\sigma_{j}^{2}}{dX_{ij}} = \frac{2}{m}(X_{ij} - \mu_{j})，路径2：\frac{d\sigma_{j}^{2}}{dX_{ij}} = \frac{d\sigma_{j}^{2}}{d\mu_{j}} \cdot \frac{d\mu_{j}}{dX_{ij}} = - \frac{2}{m}(X_{ij} - \mu_{j}) \cdot \frac{1}{m}\\\\
则\frac{d\sigma_{j}^{2}}{dX_{ij}} = \frac{d\sigma_{j}^{2}}{dX_{ij}} + \frac{d\sigma_{j}^{2}}{d\mu_{j}} \cdot \frac{d\mu_{j}}{dX_{ij}} = \frac{2}{m}(X_{ij} - \mu_{j}) + (- \frac{2}{m}(X_{ij} - \mu_{j}) \cdot \frac{1}{m}) = \frac{2}{m^{2}}(X_{ij} - \mu_{j})(m - 1)\\\\
则\frac{d\hat{X_{kj}}}{dX_{ij}} = \frac{d\hat{X_{kj}}}{d\sigma_{j}^{2}} \cdot \frac{d\sigma_{j}^{2}}{dX_{ij}} = -\frac{X_{kj} - \mu_{j}}{2(\sigma_{j}^{2} + \varepsilon)^{\frac{3}{2}}} \cdot \frac{2}{m^{2}}(X_{ij} - \mu_{j})(m - 1) = \frac{(X_{kj} - \mu_{j}) \cdot(X_{ij} - \mu_{j}) \cdot(1 - m)}{m^{2}\cdot (\sigma_{j}^{2} + \varepsilon)^{\frac{3}{2}}}\\\\
综合上述三条路径可求得\frac{dL}{dX_{ij}} = \sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{kj}}\cdot\frac{d\hat{X_{kj}}}{dX_{ij}} + \sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{kj}}\cdot\frac{d\hat{X_{kj}}}{d\mu_{j}} \cdot \frac{d\mu_{j}}{dX_{ij}} +\sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{kj}}\cdot \frac{d\hat{X_{kj}}}{d\sigma_{j}^{2}} \cdot \frac{d\sigma_{j}^{2}}{dX_{ij}}\\\\
 = \gamma\cdot\frac{dL}{dY_{ij}}\cdot\frac{1}{\sqrt{\sigma_{j}^{2} + \varepsilon }} + \sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{kj}}\cdot\frac{-1}{m\sqrt{\sigma_{j}^{2} + \varepsilon }} +\sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{kj}}\cdot \frac{(X_{kj} - \mu_{j}) \cdot(X_{ij} - \mu_{j}) \cdot(1 - m)}{m^{2}\cdot (\sigma_{j}^{2} + \varepsilon)^{\frac{3}{2}}}\\\\
 对矩阵X进行整体操作:\\\\
\frac{dL}{dX} = \gamma\cdot\frac{dL}{dY}\cdot\frac{1}{\sqrt{\sigma^{2} + \varepsilon }} + \sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{k}}\cdot\frac{-1}{m\sqrt{\sigma^{2} + \varepsilon }} +\sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{k}}\cdot(X_{k} - \mu)\cdot \frac{ (X - \mu) \cdot(1 - m)}{m^{2}\cdot (\sigma^{2} + \varepsilon)^{\frac{3}{2}}}\\\\
总结一下：\\\\
d\beta = \frac{dL}{d\beta} = \sum_{i=1}^{m}\frac{dL}{dY_{i}}\\\\
d\gamma = \frac{dL}{d\gamma} = \sum_{i=1}^{m}\frac{dL}{dY_{i}}\cdot \hat{X_{i}}\\\\
dX = \frac{dL}{dX} = \gamma\cdot\frac{dL}{dY}\cdot\frac{1}{\sqrt{\sigma^{2} + \varepsilon }} + \sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{k}}\cdot\frac{-1}{m\sqrt{\sigma^{2} + \varepsilon }} +\sum_{k=1}^{m}\gamma\cdot\frac{dL}{dY_{k}}\cdot(X_{k} - \mu)\cdot \frac{ (X - \mu) \cdot(1 - m)}{m^{2}\cdot (\sigma^{2} + \varepsilon)^{\frac{3}{2}}}\\\\
$$