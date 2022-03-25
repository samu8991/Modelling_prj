We understood we need to solve a problem like this
$$ A x = y + \eta$$
where $\eta$ is a random variable which models the noise of the environment.

So, we can use the [[LASSO]] formulation with [[L1 Regularization]] to promote sparsity.
```ad-remember
Sparsity is needed because of the formulation of the problem. If we could find an exact solution (i.e. no noise allowed) then we would have a vector $x$ such that all the components were 0 but k, which neede to be 1. All the components at $x_i = 1$ would have the meaning of "one target is at cell with label i"
```
The problem is as follows, where k is the number of target we want to localize.

Given the [[LASSO]] problem we want to recover the solution $x \in \mathbb{R}^p$ from the compressed linear measurements $y =Ax(+\text{ noise}) \in \mathbb{R}^q$ (with $q<p$) if $A$ satisfies some conditions and $x$ is k-sparse with $k << p$.

```ad-definition 
We define $S$ as the **support** of the problem. It is the set of indices of the non-zero components of our solution x. Substantially the support $S$ and the solution $x$ are equivalent.
It holds:
$$ k = ||x||_0 = |S| $$
```
Through complex mathematical tools we find interesting results, such as the [[Irrepresentable condition]], which are completely useless in real life because:
1. is tight (almost necessary and sufficient),
2. knowing $S$ is a condition of the theorem.

So, to solve our problem we use other conditions such as the [[Coherence condition]] which is based on the [[coherence of a matrix]]. The smaller the coherence, the better.
Another useful tool to reduce the [[coherence of a matrix]] is [[Feng's theorem]] which might be useful.

Finally, there are lots of algorithms for solving the [[LASSO]] problem, but we need something decentralized (so that we can use it in the feature with the agents) and that's why we introduced the [[Iterative Soft Thresholding]] algorithm, even though it was proposed as a centralized algorithm.