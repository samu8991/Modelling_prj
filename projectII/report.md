# Distribuited control of a multi-agents magnetic levitation system

> Antonio Minonne, Anna Paola Musio, Samuele Paone, Salvatore Pappalardo 
> s280095, s281988, s287804, s281621

# Introduction 

Write here

# Code explantion 

Write here 

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

$$
T_i \propto \frac{1}{\Omega_i}, \text{   where } \Omega_i = \sum_{j=1}^{d} \frac{1}{w_j}
$$

## Complete structure

Everything works fine

## Final considerations
Check wheter it is true that, if two or more nodes are conntected in a complete fashion, they have the same convergence time.

# Comparison between architectures
# Modified theory