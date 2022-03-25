# LASSO
LASSO means Least Absolute Shrinkage and Selection Operator.

The lasso method is a regression analysis method that performs both variable selection and regularization [^1]. 
The problem is stated as:
$$
	\begin{aligned}
	\underset{x \in \mathbb{R}^p}{\text{min}} \frac{1}{2} || Ax - y||^2_2 + \lambda ||x||_1,\qquad  \lambda>0
	
	\end{aligned}
$$

[^1]: From [Wikipedia](https://en.wikipedia.org/wiki/Lasso_(statistics)#General_form)