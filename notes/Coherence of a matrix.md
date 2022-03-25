Coherence of a matrix is defined as following
$$
	\mu(A) := \underset{i \ne j}{max} \frac{|A^{(i)^\intercal}A^{(j)}|}{||A^{(i)}||_2||A^{(j)}||_2}
$$

We could say it is a way to measure the _orthogonality_ of a matrix. For example, if the matrix A is orthongonal (that is $A^\intercal A=I$), then its coherence $\mu$ will be $0$.

> We can see that the formula of the coherence is similar to the cosine if the angle between two vectors:
> $cos\theta = \frac{u \cdot v}{|u||v|}$