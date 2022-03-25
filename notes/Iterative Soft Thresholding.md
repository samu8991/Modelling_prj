# Iterative Soft Thresholding (IST)
Lots of algorithms for solving the [[LASSO]] problem exists. IST is a simple yet powerful algorithm to do that. It's advantage is in the fact that it could be used in distributed networks. 

An initial estimate of the state $x_0 \in \mathbb{R}^n$ (e.g. $x_0 = 0$) and a maximum time $T_{max}$ are needed.

repeat for $t = 1,...,T_{max}$:
$$
x_t = \mathbb{S}_\lambda( x_{t-1} + \tau A\intercal (y-Ax_{t-1}) )
$$

where $\mathbb{S}$ is the soft-thresholding operator defined as follows:
$$

\mathbb{S}_\lambda := \begin{cases}
 0 \quad & \text{if} |x| \le \lambda \\
 x-sgn(x)\lambda & \text{otherwise}
\end{cases}

$$