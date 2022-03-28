Feng's  theorem is a useful tool to reduce the coherence of a matrix. It is not guaranteed to reduce it, though.

The theorem states that:
$$
y=Ax \iff z=Bx
$$
where 
$$
\begin{aligned}
& B = (\text{orth}(A^\intercal))^\intercal \in \mathbb{R}^{n,p}  \\
& A^\dagger = A^\intercal(AA^\intercal)^{-1} \in \mathbb{R}^{p,n} \\
& x = BA^\dagger y
\end{aligned}
$$