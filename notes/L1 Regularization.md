L1 regularization promotes sparsity. 

That happens because of the shape of the sets of points described by the equation
$$ ||x||_p = Q $$
Where $Q$ is given.

As visible in the image, the shape of the sets of points are "pointy" when $p \le 1$
![[Pasted image 20220320200413.png]]

so, if we want to solve linear systems like
$$ Ax = y $$
We have better chances to find sparse solutions (i.e. solutions with many zeros in their components)
![[Pasted image 20220320200959.png]]

Even though infinite solutions may occour:
![[Pasted image 20220320200944.png]]

```ad-note
**Points on the axis** are of the form $\begin{bmatrix}0_1 & ... & 0_i & 1 & 0_j & ... & 0_n\end{bmatrix} \in \mathbb{R}^n$ 
where the subscripts indicates the component
```

Reading: [Explanation for Dummies](https://blog.mlreview.com/l1-norm-regularization-and-sparsity-explained-for-dummies-5b0e4be3938a)