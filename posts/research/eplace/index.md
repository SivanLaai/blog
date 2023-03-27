# 基于电势的解析布局

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
基于上述的合法性限制，布局的目标就是最小化网表的总${HPWL}$，假定$\mathbf{v}=(\mathbf{x},\mathbf{y})$表示一个布局的方案，其中$\mathbf{x}=\{x_i|i \in V_m\}$表示所有元器件的水平坐标，$\mathbf{y}=\{y_i|i \in V_m\}$表示元器件的垂直坐标，则对于每个网表$e(e \in E)$，其半周线长的定义如下：

$${HPWL}_e(\mathbf{v}) = \max_{i,j \in e}|x_i-x_j|+\max_{i,j \in e}|y_i-y_j| \tag 1$$
则总半周线长定义为：
$${HPWL}(\mathbf{v}) = \sum_{e \in E} {HPWL}_e(\mathbf{v})$$
布局问题定义为如下：
$$\min_\mathbf{v}{HPWL}(\mathbf{v})，使得\mathbf{v}是一个合法的布局方案 \tag 2$$
### 全局布局的定义
把布局区域$R$按$m*m$划分成一个一个的格子（称作bin），这些格子的集合是B，其中$\rho_b(\mathbf{v})$表示每个b的密度，其定义如下：
$$\rho_b(\mathbf{v}) = \sum_{i \in V} l_x(b,i)l_y(b,i) \tag 3$$
其中$l_x(b,i)$和$l_y(b,i)$分别表示元器件i和格子b之间的水平和垂直重合，全局布局的定义如下：
$$\min_\mathbf{v}{HPWL}(\mathbf{v})\ s.t.\rho_b(\mathbf{v})\leq \rho_t, \forall b \in B \tag 4$$
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
电势和电场分布由系统中的所有元素决定，在网表中的每个节点（元器件或者宏块）带正电苛的粒子i。粒子的带电量$q_i$表示为节点的面积$A_i$，根据洛仁力量定律(Lorentz force law)定义的电力$F_i=q_i \upxi_i$可移动的节点i的运动

## 泊松方程
用来解决优化问题内部的计算，主要用于求解FFT计算

---

> 作者: [SivanLaai](https://www.laais.cn)  
> URL: https://www.laais.cn/posts/research/eplace/  

