# Nearest Neighbor
## Autonomous sensor
Each sensor mught determine the position of the target alone, based on the fingerprint.
### Single measurement
```ad-note
All the discussion ahead is based on the fact that **different fingerprint have different value** but it is not always the case. 
```

When each sensor only stored one measurement in the dictionary $A \in \mathbb{R}^{n,p}$, then the problem is as follows:
$$\begin{equation} \widehat{\text{j}} = \underset{j=1,...,p}{\text{argmin}} |{A_{i,j}-y_i}| \end{equation}$$
Whic means, 
```ad-important
we want to find the row of $A$ which is the most similar to the measuremtnt $y$.
```
### Multiple measurement
When $m > 1$ each sensor will have a matrix A which has $n\times m$ dimensions:
$$ A(i) = \begin{pmatrix}
	A_{i_1,1} & A_{i_1, 2} & \cdots & A_{i_1,p} \\
	A_{i_2,1} & A_{i_2, 2} & \cdots & A_{i_2,p} \\
	\vdots    &  \cdots    & \cdots &  \vdots \\
	A_{i_m,1} & A_{i_m, 2} & \cdots & A_{i_m,p} \\
\end{pmatrix} $$
and each sensor may localize the target as follows:
$$ \hat{\text{j}} = \underset{j=1,...,p}{\text{argmin}} || A(i)^{(j)} - y_i \mathbf{1}_m ||^2_2 $$
Where $A(i)^{(j)}$ is the j-th column of A(i)
$$ A(i)^{(j)} = \begin{pmatrix}
					A_{i_1,j} \\
					A_{i_2,j} \\
					\vdots    \\
					A_{i_m,j} 
			  \end{pmatrix} $$
and $\mathbf{1}_m = (1, ..., 1)^T \in \mathbb{R}^m$
So the equation becomes:
$$ \hat{\text{j}} = 
\underset{j=1,...,p}{\text{argmin}}
	\begin{Vmatrix}
	\begin{pmatrix}
		A_{i_1,j} \\ \vdots \\ A_{i_m,j}
	\end{pmatrix}
	-
	\begin{pmatrix}
		y_i \\ \vdots \\ y_i
	\end{pmatrix}
	\end{Vmatrix}^2_2
$$
These equations have the same mining as before:
```ad-important
Find the label $j$ such that the multiple measurement $A_{i_m,j}$ are in total the most similar to $y_i$
```


## Centralized unit
### Single measurement
The equation above becomes as follows:
$$ 
	\hat{\text{j}} = \underset{j=1,...,p}{\text{argmin}}||A^{(j)} - y ||^2_2 \
$$
Where $A^{(j)} = (A_{1,j}, ... , A_{n,j})^T$
### Multiple measurement
Same in this case:
$$
	\hat{\text{j}} = \underset{j=1,...,p}{\text{argmin}}
	\sum_{i=1}^{n}||A(i)^{(j)} - y_i \mathbf{1}_m ||^2_2 \
$$
## Considerations
The main point of this method is finding good values for p, n and m bacuse each of them has great impact on perfomances and precision.
| Smaller               | Value | Greater          |
| --------------------- | ----- | ---------------- |
| Faster computation    | p     | Great precision  |
| Cheaper               | n     | More expensive   |
| Faster initialization | m     | Better perfomace |

So everything has to be calibrated.