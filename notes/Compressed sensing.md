Compressed sensing is the problem of finding a $k\text{-sparse}$ solution to the following problem:
$$
\begin{aligned}
Ax &= y+\eta \\
s.t. \\
x & \in \mathbb{R}^p \\
y & \in \mathbb{R}^q \\
A & \in \mathbb{R}^{q,p} \ | \ q < p
\end{aligned}
$$
where $\eta \sim \mathcal{N}(0, \sigma)$ and
$$ k <\!< p $$

In other words[^1] 
> CS theory states that a k-sparse vector x can be recovered from compressed linear measurements y=Ax if A satisfies some conditions

In this context we define the [[Support]]

```ad-important
The compressed sensing problem can be generalized with the [[LASSO]] formulation, so the problem can be stated as 
$$
	\begin{aligned}
	\underset{x \in \mathbb{R}^p}{\text{min}} \frac{1}{2} ||Ax - y||^2_2 &+ \lambda ||x||_1, \qquad \lambda>0 \\
	&s.t. \\
	y &= aX - \eta \\
	\end{aligned}
$$
```

Further readings: _[Compressed sensing](https://en.wikipedia.org/wiki/Compressed_sensing)_.

[^1]: Dohono, 2006