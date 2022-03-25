# Irrepresentable condition (IIR)
To solve [[Compressed sensing]] problem with the [[LASSO]] formulation, the following result holds.

The irrepresentable condition[^1] states that
Given the problem as defined above

Let $\bar{\text{S}} =\{1,...,n\} \setminus S$ where $S$ is the [[Support]].
Then, if $A$ satisfies the $(\omega, S)\text{-IRR}$, i.e.

**if**
$$ \exists \  \omega > 0 \; \text{s.t.} \; \underset{j\in\bar{\text{s}}}{max}||A^{(j)^\intercal}A^{(S)}(A^{(S)^\intercal}A^{(S)})^{-1}||_1 \le \frac{1}{\omega} $$
**then**
- $\omega > 1 \Leftrightarrow$ we talk about **strong** $(\omega, S)\text{-IRR} \Rightarrow$ the solution to the Lasso identifies the correct support,
- $\omega = 1 \Leftrightarrow$  we talk about **strong** $(\omega, S)\text{-IRR} \Leftarrow$ the solution to the Lasso identifies the correct support.

```ad-info
The notation $A^{(S)}$ has the meaning of having a matrix built such that it has only the columns are those with indexes of S:
$$
A^{(S)} = \begin{pmatrix}
	& \mid & \\
	\cdots & c_i & \cdots \\ 
	& \mid &
\end{pmatrix}, \qquad \forall i \in S
$$

where

$$
A = \begin{pmatrix}
	\mid & & \mid\\
	c_1 & \cdots & c_n \\ 
	\mid & & \mid
\end{pmatrix}
$$


```

[^1]: Maybe Tibshirani, 1996 (But not sure)