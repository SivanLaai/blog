---
title: 基于电势的解析布局
date: 2023-03-27T16:33:04+08:00
categories:
  - 研究
tags:
  - 论文阅读
---
# 基于电势的解析布局

## 基本概念
### 布局的定义
布局问题可以描述为一个超图问题，可以定义为如下：
$$G = (V,E,R)$$
其中$V$表示元器件（顶点）集合，$E$表示网表（超边）集合，$R$表示布局区域。在$V$中$V_m$表示可移动器件的集合，$V_f$表示固定块集合。令$n=|V_m|$表示可移动布局对象的个数。
一个合法的布局解决方案应该要满足下面三个要求：
- 在布局区域中使用足够的空闲位置容纳每个器件
- 每个元器件在水平方向上要和布局行的边界对齐
- 元器件和宏组件不能有重合

基于上述的合法性限制，布局的目标就是最小化网表的总$HPWL$，假定$\mathbf{v}=(\mathbf{x},\mathbf{y})$表示一个布局的方案，其中$\mathbf{x}=\{x_i|i \in V_m\}$表示所有元器件的水平坐标，$\mathbf{y}=\{y_i|i \in V_m\}$表示元器件的垂直坐标，则对于每个网表$e(e \in E)$，其半周线长的定义如下：

$$HPWL_e(\mathbf{v}) = \max_{i,j \in e}|x_i-x_j|+\max_{i,j \in e}|y_i-y_j| \tag 1$$
则总半周线长定义为：
$$HPWL(\mathbf{v}) = \sum_{e \in E} HPWL_e(\mathbf{v})$$
布局问题定义为如下：
$$\min_\mathbf{v}HPWL(\mathbf{v})，使得\mathbf{v}是一个合法的布局方案 \tag 2$$
### 全局布局的定义
把布局区域$R$按$m*m$划分成一个一个的格子（称作bin），这些格子的集合是B，其中$\rho_b(\mathbf{v})$表示每个b的密度，其定义如下：
$$\rho_b(\mathbf{v}) = \sum_{i \in V} l_x(b,i)l_y(b,i) \tag 3$$
其中$l_x(b,i)$和$l_y(b,i)$分别表示元器件i和格子b之间的水平和垂直重合，全局布局的定义如下：
$$\min_\mathbf{v}HPWL(\mathbf{v})\ s.t.\rho_b(\mathbf{v})\leq \rho_t, \forall b \in B \tag 4$$
#### 线长平滑化
每一个网表$e={(x_1,y_1),(x_2,y_2),\cdots,(x_n,y_n)}$有n个引脚 ,对数和指数（LSE）在水平轴x方向的线长平滑公式如下：
$$W_e(\mathbf{v}) =\gamma 
\begin{pmatrix}
ln\sum_{i \in e} exp(\frac{x_i}{\gamma})+ln\sum_{i \in e} exp(\frac{-x_i}{\gamma})
\end{pmatrix}
\tag 5$$
其中${\gamma}$是平滑参数，不能随意设置的足够小。
权重平均（WA）在水平轴x方向的线长平滑公式如下：
$$W_e(\mathbf{v}) =
\begin{pmatrix}
\frac{\sum_{i \in e} x_iexp(\frac{x_i}{\gamma})}{\sum_{i \in e} exp(\frac{x_i}{\gamma})}
-
\frac{\sum_{i \in e} x_iexp(-\frac{x_i}{\gamma})}{\sum_{i \in e} exp(-\frac{x_i}{\gamma})}
\end{pmatrix}
\tag 6$$
### 密度惩罚
在实际的布局当中，$|B|$个格子的密度都需要满足限制，我们把这些限制用一个惩罚项$N(\mathbf{v})$来表示，当惩罚项$N(\mathbf{v})=0$时所有的密度都满足，其定义如下：
$$\rho_b(\mathbf{v})\leq \rho_t, \forall b \in B \iff N(\mathbf{v})=0 \tag 7$$
用二次惩罚项来表示如下：
$$N(\mathbf{v})=\sum_{b \in B }(\widetilde \rho_{b}(\mathbf{v})- \rho_t)^2 \tag 8$$
其中$\widetilde \rho_{b}$表示在Naylor et al. 2001中定义的铃状的平滑密度函数，密度惩罚$N(\mathbf{v})$也用来表示系统的势能。
### 非线性布局优化方程
利用惩罚因子$\lambda$目标函数$f(\mathbf{v})$的定义：
$$\min_\mathbf{v} f(\mathbf{v}) = W(\mathbf{v})+\lambda N(\mathbf{v}) \tag 9$$
也可以用拉格郎日乘子法写成下面的形式：
$$\min_\mathbf{v} f(\mathbf{v}) = W(\mathbf{v})+\sum_{b \in B}\lambda_b|\widetilde \rho_{b}(\mathbf{v})- \rho_t| \tag{10}$$
其中$\lambda_b$表示每个格子b的密度限制参数乘子

## 静电系统建模（eDensity）
电势和电场分布由系统中的所有元素决定，在网表中的每个节点（元器件或者宏块）带正电苛的粒子i。粒子的带电量$q_i$表示为节点的面积$A_i$，根据洛仁力量定律(Lorentz force law)定义的电力$F_i=q_i \xi_i$，会引起可移动的节点i的运动，$\xi_i$表示节点i的布局电场。同样的$N_i=q_i \psi_i$表示节点的势能，$\psi_i$表示器件i的电势大小。根据库仑定律，器件i的电场和电势是系统中剩余器件共同作用的叠加。
整个布局的电苛密度分布表示为$\rho(x,y)$，$\xi_x(x,y)$表示水平电场的分布函数，表示$\psi(x,y)$电势分布函数。
![](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230327164926.png)
### 静电平衡系统建模
布局系统和静电系统的建模图：

![](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230327165122.png)

根据建模规则，把均匀分布的全局布局约束同静电平衡的系统状态联系起来，电力为帮助指引电苛（元器件）的向着平衡状态的方向移动。根据高斯法则，电场等于电势的负梯度，如下定义：
$$\xi(x,y)=(\xi_x,\xi_y)=-\nabla\psi(x,y)=
\begin{pmatrix}
-\frac{∂\psi(x,y)}{∂x},-\frac{∂\psi(x,y)}{∂y}
\end{pmatrix} \tag{11}$$
电苛的密度函数等于电场函数的散度
$$\rho(x,y)=\nabla \cdot \xi(x,y)=-\nabla \cdot \nabla\psi(x,y)=-
\begin{pmatrix}
\frac{∂^2\psi(x,y)}{∂x^2}+\frac{∂^2\psi(x,y)}{∂y^2}
\end{pmatrix} \tag{12}$$
静电系统如果只有正电苛那么只会产生排斥力，相应的静电平衡状态会把所有的器件沿着边界进行分布，因为在边界上可以违反布局约束。因此需要从密度分布当中移除直流组件（即0频率组件）去产生负电苛，从而整个布局区域的密度函数整体变为0。
具体一点说，因为密度函数把所有的对象转化成了正电苛，因此就产生了一个正电苛密度分布。然后就是当直流电移除后，需要填充的区域的电量会比原来有直流电的时候的电量更小，因此就变成了负电苛。同时过于填充的区域依然是正电苛（但是电量比原来小了）。正电苛多的地方会向着负电苛区域移动，相互中和，从而达到一个静电平衡的状态。使得整个系统在布局区域内达到电苛密度为0并且电势也降到0。
这样就把布局的密度惩罚和梯度建模为了势能和电场。‘
### 密度惩罚和梯度
势能的总和等于新的元器件集合$V^{'}$中所有带电元素的势能之和，这些元素包含了来自$V$中的可移动节点、固定宏节点，也包含了下一步要讨论的填充节点和暗节点。
#### 填充节点插入
![](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230327191136.png)
![](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230327191149.png)
上图中的黑色长方形表示宏元器件，红点表示标准元器件，蓝点表示填充节点，随着填充节点充斥在空白区域，有了更小的总线长，同时器件也挤压在了一起，相互离的更近。

$A_m$表示可移动节点的总面积，$A_{ws}$表示空白空间的总面积。如果目标密度是$\rho_t \geq \frac{A_m}{A_{ws}}$，均匀密度分布会过度的把器件平铺，引起了不必要的线长增加。填充节点（filler cell）都是等尺寸（距形）的，可以移动和并且是断连（0引脚）。$A_{fc}$表示填充节点的总面积，定义如下：
$$A_{fc} = \rho_tA_{ws}-A_m \tag{13}$$
每个填充节点$i$的面积是$A_i$，这个是由可移动器件的面积分布所决定的。每个填充节点的尺寸是可移动器件的中间80%的平均尺寸。填充节点的插入会增加额外的密度力，这会使得元器件和他的连接器件之间的距离更小，同时也会满足密度约束。全局布局结束以后，所有的填充节点都会删除。
### 暗节点插入
用一个均匀的网格$R(m*m)$铺在所有的布局区域上，$R$里面不属于任何布局区域的所有空间都会被划分成一个包含很多长方形格子的集合，每一个格子就是一个暗节点， 对于暗节点的处理方式和固定器件的处理方式一致。$V_d$表示所有的暗节点集合，$A_d$表示所有的节点的总面积。当可移动节点到达布局的边界上时，可移动节点会因为受到暗节点的排斥力而停止。
### 密度缩放
填充节点插入后，目标密度就变成了$\rho_t = \frac{A_m+A_{fc}}{A_{ws}}$。为了去维持全局等效的密度分布，每一个固定节点或者暗节点$i$的面积$A_i$都需要通过$\rho_t$进行缩放，否则密度力会变得比填充物的密度力更大，并把器件排斥开，固定结点周围的空白区域会被置空，也会增加下图所示的线长开销。
![](https://cdn.staticaly.com/gh/SivanLaai/image-store-rep@master/note/20230327200255.png)
上图中(a)和(b)在没有密度缩放的情况下，在大组件上网格的密度会高于目标密度，从而密度力会把器件从大组件周围推开，从而引起了宏组件周围更多待填充的空白区域和线长开销。
### 势能计算
$V^{'}=V_m \bigcup V_f \bigcup V_{fc} \bigcup V_d$表示系统中所有元素的集合，对于每一个节点$i \in V^{'}$，$\rho_i$、$\xi_i$和$\psi_i$分别表示该节点的电密度、电场和电势。给定一个可移动器件集合$V_m$和填充节点集合$V_{fc}$的布局方案$\mathbf{v}$，其总的势能如下表示：
$$N(\mathbf{v})=\frac{1}{2}\sum_{i \in V^{'} }N_i=\frac{1}{2}\sum_{i \in V^{'} }q_i\psi_i \tag{14}$$
因为系统的势能会等于所有的电苛的相互作用之和，所以每个单节点需要乘以$\frac{1}{2}$，把重多网格密度约束问题转化成了一个0势能系统的单一势能约束$N(\mathbf{v})=0$。通过引入惩罚因子$\lambda$，一个不受约束的优化问题如下：
$$\min_\mathbf{v} f = W(\mathbf{v})+\lambda N(\mathbf{v}) \tag{15}$$
其中$W(\mathbf{v})$是来自方程6，$f(\mathbf{v})$表示的是最小化的代价函数。因为$W(\mathbf{v})$和$N(\mathbf{v})$都是平滑的，我们可以通过求微分得到如下的梯度向量$\nabla f(\mathbf{v})$：
$$\nabla f(\mathbf{v}) = \nabla W(\mathbf{v})+\lambda\nabla N(\mathbf{v})=
\begin{pmatrix}
\frac{∂W}{∂x_1},\frac{∂W}{∂y_1},\cdots
\end{pmatrix}^T - \lambda(q_1{\xi_1}_x,q_1{\xi_1}_y,\cdots)^T
\tag{16}$$
## 泊松方程
用来解决优化问题内部的计算，主要用于求解FFT计算