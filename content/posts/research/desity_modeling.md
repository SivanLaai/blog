## 密度函数平滑技术
当前的密度模型主要分为两类：（1）局部平滑和（2）全局平滑
### 局部平滑
局部平滑函数用一个钟形的二次函数来替代原来的线性密度函数，只包含了局部的信息，可能会要消耗更多的迭代次数才能收敛。
### 全局平滑
使用椭圆PDE去做平滑，现代非线性布局当中是主流的应用。全局信息的纳允许大规模的器件运动。在文献《T. F. Chan, J. Cong, J. R. Shinnerl, K. Sze, and M. Xie. mPL6: Enhanced Multilevel Mixed-Size Placement. In ISPD , pages 212–214, 2006.》中使用Helmholtz 方程来求密度如下：

$$\nabla\psi(x,y)-\epsilon\psi(x,y)=\rho(x,y),(x,y)\in R$$

其中$\psi$表示平滑后的密度分布，当线性因子$\epsilon \gt 0$，有唯一解。