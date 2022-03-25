We can define [[Centralized settings]]
In an ideal case, if we have a dictionary $A \in \mathbb{R}^{n,p}$ and n measuerments $y \in \mathbb{R}^n$ then it's possibile to find the label $j$ such that it satisfies the following equation:
$$ A_{i,j} = y_i \ \ |\  \forall i=1...n $$
In reality that never happens, so we use the [[Nearest Neighbor (NN)]] method which is suitable if there are noisy measurements.
NN method is slow and has to be calibrated in its parameters, so there other formulation of the same problem:
$$
\begin{aligned}
	Ax &= y \\
	& s.t. \\
	& x \in \{0,1\}^p \\
	& \sum_{j=1}^p x_j = 1
\end{aligned}
$$
But this kind of problems is hard to solve (i.e. computationally intense).
So relaxation comes in play making $x \in \mathbb{R}$ 
But to do that we need to promote sparsity, hence the [[LASSO]] problem helps to solve our needs.