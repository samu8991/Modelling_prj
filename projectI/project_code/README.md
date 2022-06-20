# CPS project - Part 1

This project has three main purposes, each one specified by an experiment.

- experiment A: Compute the rate of success of the DIST and O-DIST algorithms and the average error when the estimation of the target is unsuccessful,
- experiment B: Compute the average convergence time (expressed in iterations) for the IST and DIST algorithms to converge. We also added an error measurement of the estimates.
- experiment C: Copute the relationship between the convergence time and the essential spectral radius of the graph describing the connections between the agents.

---

The most important files in this directory are:

1. experiment_a.m
2. experiment_b.m
3. experiment_c.m

which are heavily based on another three important files:

4. IST.m
5. DIST.m 
6. ODIST.m

The names are self-describing. 

The other files are functions which are called by the files above.

Most of the things are explained and suitably commented.
