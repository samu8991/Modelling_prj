# Distribuited control of a multi-agents magnetic levitation system

> Antonio Minonne, Anna Paola Musio, Samuele Paone, Salvatore Pappalardo 
> s280095, s281988, s287804, s281621

# Introduction 

This project implements a system of 6 distribuited magnetic levitation systems, leanirized in an equilibrium point. We applied the theory as described in section 3 of the book [Cooperative Control of Multi-Agent Systems](https://link.springer.com/book/10.1007/978-1-4471-5574-4). 
In the first section we briefly explain the simulink model and the code used for the simulations, as well as the other files of the project. The second section briefly analize the performance of different network structures in terms of Global Disagreement Error on the output of the systems. The third section is dedicated to the comparison of the performances when using either a distributed observer or a local one. Finally, the last section explains a slightly different architecture that works for our systems, even tough we could not proove the general case.

# Files arrangement

For information about the simulink and matlab implementation, please refer to the file README.md.

There are 4 types of files.

## `stable_` prefix
These files are related to the theory as seen in class lessons. Each magnetic levitator is controlled using the pole-placement method. In order to do that, since the state of the system is not measureable, we neede to add an observer which provided the state, given its output.

The "placed poles" are chosen in order to impose a specific trajectory to the leader. 

Each other agent is virtually connected to all the otget agent. Whether the connection actually exists depend on the adjacency matrix of the graph.

Each agent also have an observer as explained by the theory, which serve the purpose of estimating the controlled state to calculate $\epsilon$. This kind of architecture is a bit redundant, since we already have an observer, but it is necessary to underline that the two observer estimate different states, specifically: the internal one estimate the actual state of the maglev, the external one estimate the state of the **controlled maglev**.

## `alternative_` prefix

These files are relative to the _slightly different_ architecture as mentined above. For further informations, read the last section of this document. 

Regarding the files, they are an almost exact copy of the `stable_` files.

# `metric_` prefix

These files contain useful functions needed to score the performance of the system.

The file `metrics.txt` contains a description of each implemented metric.

# `v` prefix
Each of these files contains a different configuration for the system. The file versions.txt explains what each version does.


# Network structure analysis

## Chain structure

## Tree structure

The tree structure is shown in the following figure

![](tree_general.png)

We anayzed 6 different network configurations with different weights. Those are summurized in the following table. 

| n   | Configuration         | 0->1 | 0->2 | 1->3 | 1->4 | 2->5 | 2->6 |
| --- | --------------------- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1   | Equal weights at 1    | 1    | 1    | 1    | 1    | 1    | 1    |
| 2   | Increasing weights    | 1    | 1    | 10   | 10   | 10   | 10   |
| 3   | Decreasing weights    | 10   | 10   | 1    | 1    | 1    | 1    |
| 4   | Same convergence time | 1    | 1    | 100  | 100  | 100  | 100  |
| 5   | Big equal weights     | 1e10 | 1e10 | 1e10 | 1e10 | 1e10 | 1e10 |
| 6   | Asymmetric weights    | 1    | 10   | 1    | 10   | 1    | 10     |

The following figures illustrates the step response and the **global disagreement error** (GDE) with respect to the output of each system.

![](img/tree_step_response.png)

![](img/tree_step_response_errors.png)

The first notable thing is that the convergence time does not depend on the value of the weight itself, but rather there seems to exist a relationship which quantifies the similarity of the behaviours and the convergence times.

Where $d$ is the depth of the node and each $w_j$ is the weight of the edge on the j-th step.
- the convergence time,
- the depth of the considered node,
- the product of the weights of the traversed edges.

Indeed, when comparing `Configuration 1` and `Configuration 5` (in which the difference is only the magnitude of the weights) we can clearly see that they have the same behaviour even though completely different weights. 
On the other hand, `Configurations` `1`, `2` and `4` have increasingly similar behaviour, with the slower nodes matching the behaviour of the faster ones.

Another important aspect to underly is the _class of convergence_. In the context of the first five configurations, only two curves are clearly visibile. This happens because nodes `s1` and `s2` converge at the same time: they _belong to the same class_.  The same can be said for nodes `s3`, `s4`, `s5` and `s6`.

Altough there seems to be a simple relationship, the next example demonstrates things are more complicated. 

In `Configuration 6` the tree is _unbalanced_ and this fact heavily modify the behaviour. The table shows the convergence times of the nodes for this configuration in increasing order:

| node | convergence time |
| ---- | ---------------- |
| 2    | 9.13             |
| 6    | 9.62             |
| 1    | 11.21            |
| 4    | 11.32            |
| 5    | 11.32            |
| 3    | 12.01            |

It seems that these times follow the next constraint
$$
T_i \propto \frac{1}{\Omega_i}, \text{   where } \Omega_i = \sum_{j=1}^{d} \frac{1}{w_j}
$$

It is clear that the bigger the weight and smaller the depth, the faster the convergence. Node `s2` has de 1 and weight 10, thus is the first to converge. The second place belongs to `s6` which is a direct child of `s2` and has again a weight of 10. Then, `s1` converges and it has depth 1, but weight 10 and next we find `s4`, which is a direct child of `s1` and has weight 10. Finally `s2` is a direct child of `s2` (si, depth 2) but has weight 1 and `s3` has depth 2 but weight 1.

To further investigate the relationship with the depth, we experimented with another network structure, which is presented in the following section.

## Dictator structure
We called "dicator" the structure in which each agent is directly connected with the leader and no-one else. The following figure illustrate the concept.

![](img/dictator_general.png)

We used 6 configurations once again. They are listed below.

| n   | Description          | 0->1 | 0->2 | 0->3 | 0->4 | 0->5 | 0->6 |
| --- | -------------------- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1   | Equal weights at 1   | 1    | 1    | 1    | 1    | 1    | 1    |
| 2   | Equal weights at 1e3 | 1e3  | 1e3  | 1e3  | 1e3  | 1e3  | 1e3  |
| 3   | Equal weights at 1e6 | 1e6  | 1e6  | 1e6  | 1e6  | 1e6  | 1e6  |
| 4   | Equal weights at 1e9 | 1e9  | 1e9  | 1e9  | 1e9  | 1e9  | 1e9  |
| 5   | Powers of 10         | 1    | 10   | 10^2 | 10^3 | 10^4 | 10^5 |
| 6   | Powers of 1000       | 1    | 1e3  | 1e6  | 1e9  | 1e12 | 1e15     |

The error are as illustrated in the following image

![](img/dictator_step_response_errors.png)

The first remarkable point is that Configurations `1`, `2`, `3` and `4` have the same behaviour. This results, paired with the previous one, indicates that the **convergence time is the same when all the weights are the same**.

The last two example shows a relationship of the type $T_i \propto \frac{1}{w_i}$, where $T_i$ denotes the convergence time of node i and $w_i$ is the pinning gain for the same node.

Configuration `5` is interesting because it shows us what seems to be a super-exponential relationship between the weights and the convergence time. The next figure shows the semilogx plot of the convergence time with respect to the weights.

![](img/dictator_super_exponential.png)

## Double-chain structure
The double-chain structure is a tree in which the leader has 2 childs and each child has only one child, as follows.

![](double_chain_general.png)

Analyzing this structure and pairing the results with the _signle_-chain structure, it appears very clear that there is inverse proportional relationship between the depth and the convergence time. This result corroborates the unknown relationship of the graph structure, which shuold be general for _one-way_ networks.

$$
	T_i \propto \frac{1}{d_i}
$$

![](img/double_chain_step_response_errors.png)

And also that exists some kind of relationship between the convergence time and the ratios of the weights along the chain.

## Complete structure

The complete structure is shown in the following figure.

![](img/complete_general.png)

In this structre, each node communicates with each other node. The leader is connected to every agent. 
This structure is peculiar, since it produces always the same results, no matter what weighs are chosen. In the following figure, we show the GDE for four different configurations.

| n   | description      | weights |
| --- | ---------------- | ------- | 
| 1   | Equal weights    | 1       | 
| 2   | Equal weights    | 100     | 
| 3   | Eandom weights 1 | random  | 
| 4   | Random weights 2 | random  | 

![](img/complete_step_response_errors.png)
This happens because each node receives always the same informations, even though with different weights. The peculiarity is that the informations kind of average always out , thus producing always the same results. 

Altough this is the most reliable structure (both in terms of performance and reliabilty) it also is the most expensive, needing to connect every node six times.

## Final considerations

Summing up the conclusion we can say that if:

1. the graph is acyclic and
2. at least one weight is different from the others

then the following relationship holds

$$
T_i \propto \Omega_i, \text{   where } \Omega_i = \sum_{j=1}^{d} \frac{1}{w_j}
$$
While, if the weights are all the same, tje convergence time only depends on the network topology.

Although we weren't able to find some clear relationship between the convergence times and the network structure, we are pretty sure this same problem was already studied in the past. References like [1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5638610) seem to have studied this problem. Also we should be able to apply [Flow network theory](https://en.wikipedia.org/wiki/Flow_network) to study this problem. 

In thi section we now discuss the chosen network, in terms of cost and performance.

================DA SCRIVERE!!!!================

# Comparison between architectures
## Cambiando il segnale generato dal leader
## Cambiando il rumore di misurazione
## Cambiando c, Q e R
# Modified theory
Initially we wanted to control the maglev using the observer given by the theory. The problem was that the observer estimates only the state of the stabilized system, making it useless for our purposes. Throught trial and error, we reached a point such that the estimation was the one we expected. We shall now explain this fact from a mathematical point of view.

We have the following system:
$$
\begin{cases}
	\dot{x} = Ax + Bu \\
	y = Cx	
\end{cases}
$$

We define $K^\star$ using the pole placement method, such that
$$
\begin{cases} 
	\dot{x} = Ax + Bu \\
	u = -K^\star x + r
\end{cases}
$$
is stable.

Defining $A' = A-BK^\star$ 

Following the theory, we design a controller $K$ as explained by theory.
$$
K = R^{-1} B^T P
$$
where P is the solution to the Algebraic Riccati Equation

$$
A'P + PA'^T + Q - PB^TR^{-1}BP = 0
$$


Finally, and this is where we made our modification, we define the observer as follows

$$
	F = P C^T R^{-1}
$$
where P solves

$$
AP + PA^T + Q - PB^TR^{-1}BP = 0
$$

The point here is that we are using $A$ instead of $A'$.

Using Theorem 3.2, we can show that the system converges using the Lyapunov equation

$$
(A - c \lambda_i F C P) + P (A - c \lambda_i F C)^*  = - Q - (2 c \alpha_i -1) F R F^T
$$
to find that $M_o = A-c \lambda_i F C P$ is Hurwitz for each $i$.

The problem to conclude the proof was to find som kind of relationship between eigenvalues $A$ and the eigenvalues of $F$ and eventually with the eigenvalues of $M_i$.

To conlcude, we show the equations for each agent.
$$
\begin{cases}
		  \dot{x_i} = Ax_i + Bu_i \\
		  u_i = cK \epsilon_i - K^\star \hat{x} \\
		  \epsilon_i = g_i ( \hat{x_0} - \hat{x_i} ) + \sum_{j=1}^{N} a_{ij} (\hat{x_j} - \hat{x_i}) \\
		  \dot{\hat{x_i}} = A \hat{x_i} + B u_i - cF \zeta_i \\
\end{cases}
$$

Where 

$$
\begin{cases}
		  \zeta_i = g_i ( \tilde{y_0} - \tilde{y_i} ) + \sum_{j=1}^{N} a_{ij} (\tilde{y_j} - \tilde{y_i}) \\
		  \tilde{y_i} = y_i - \hat{y_i} \\
		  y_i = Cx_i \\
		  \hat{y_i} = C \hat{x_i}
\end{cases}
$$

We analyzed such a system and computed the Synchronization Region. The following figure shows the synchronization region for the oberserved system $(A, C)$.

![](img/observer_convergence.png)
This plot shows us, under the conditions we designed the controller and the observer, the system converges.

This is surely a particular case, but this new method assures the existance of some conditions on $A$ such that this architecture is stable.
