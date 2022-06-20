# Title
### A project of target localization and tracking 
> Antonio Minonne, Anna Paola Musio, Samuele Paone, Salvatore Pappalardo 

## Introduction 
Software per utilizzare markdown -> https://obsidian.md/


## Code explantion 
There are three categories of files:
- experiments,
- algorithms implementations,
- helper functions
We shall explain each file within each category.

### Experiments files
These are the most important files. They containts the code used for generating data and analyze it.  The detailes of the experiments are discussed in the "Result and Analysis" section.
### Algorihtms implementations files
There are 3 files: IST.m, DIST.m and ODIST.m each of which is exactly what it sounds like. They are implemented as functions, as everything in this project but the experiments, for ease to use.
#### IST
The Iterative Soft Thresholding algorithm is centered. It works as following:

1. Deploy the sensors: the sensors are deployed (using a helper function) inside the room and are positioned accordig to the requested type. If random-positioned, the deployment is the same, with the same seed.
2. Position the target: the target position might be received as an argument. If the `target` parameter is a scalar (i.e. `size(target) == [1 1]`), then, it is randomly positioned. When randomly-positioned, the coordinates are the same with the same seed.
3. Training of the senosors: in this phase the dictionar $A$ is created using a helper function.
4. Q computation: this step is unnecesary, but it is historically put since this file was born after DIST.m
5. Initial condition inizialitazion: x0 gets computed. It can be passed as a parameter, this was done to use the file for the O-IST, which was nevere implemented. If the parameter x0 is a scalar (i.e. `size(x0) == [1 1]`), then x0 is initialized at 0.
7. Measurements: in this step each sensor gets its measure using an helper function.
8. Feng's theorem: in order to reduce the coherence of the matrix A and to produce a less sparse solution (k > 1), Feng's theorem is applied to A and y producing B and z.
9. IST algorithm: This is the most important step of the procedure. Here the algorithm is applied using the IST_step function (which is defined at the end of the same file). The complete history of the `x` vector is mantained, due to the relative small dimensions. Another important thing is that _early stopping_ is applied. When the 1-norm (or the 2-norm depending on the case) of `x` drops below `stopThreshold` the algorithm is stopped. This is equivalent to saying that the algorithm converged. 
10. Results: this section of the code contains an explantion of the output parameter of the function, including the sizes.
11. Plots: if `showPlots` is true, three figures are shown: the first contains a representation of the room, with target, best estimate and sensor positions; the second one shows the difference `x(t)-x(t-1)` for each `t` and for each component of x; the last one show `x` when consensus is reached. 
The IST_step function does two operations on `x` . It firstly computes applies the gradient descent to `x` and then applies the soft-thresholding operator to the result of the former operation.

### DIST.m  

The DIST algorithm is implemented pretty much as the IST one. We shall describe the differences using the same numerations of the previous chapter.

4. Q computation: it is made through the `init_Q` helper function, but this time is very useful, since its informations will be used for applying the Distribute Iterative Soft Thresholding. A sidenote is that `eps` is a number in the range \[0, 1\] which correspond to the percentage for the actual $\epsilon$ in the Q matrix (using uniform weights). Specifically is the percentage between 0 and the maximum $\epsilon$ permitted, which is $\frac{1}{max(d_i)}$ where $d_i$ is the in-degree of the i-th sensor.

9. DIST algorithm: during this cycle, the DIST algorithm is applied to each `x` of each sensor. In this code there are checks over the values of x. These were added when trying  to aplly the algorithm with more than one measurement per sensor or when the number of sensors is changed. The complete explanation is in the "Extensions" section. For each sensor is then computed the average state of the neighbors and the `DIST_step` function is called. When the difference of the 1-norm (or 2-norm) average of the vectors is below `stopThreshold` the algorithm stops. This is unfeasible in real-life, but it was implemented in this way in order to compare it with the DIST algorithm.

10. The big difference here is that x does not contain the full history of the x vector, but only the best estimate. Furhtermore, x_diff contains only the euclidean norm of `x` for each sensor for each time t. Finally, p_bar is computed as the average of the coordinates of all the best estimates.
Exactly as `IST_step`, `DIST_step` computes the gradient descent with respect to the average state of the neighbors and then applies the soft thresholing operator.

### Helper functions files

We shall write a full list with the brief explanation of each file. Some custom notation is introduced.

- arrow - this file prints an arrow in a plot. It can be found on the matlab website
- cell2pos - converts an index of the room (which wi call cell) to a two coordinate position. It is also possibile to plot the pos as a green square.
- deploy - contains a function for deploying the senors. They might be deployed in a grid fashion or randomly. If the deployment is random, then the algorithm computes the positions such that a spanning-tree exists and the sensors are at least `min_radius` meters apart. Default: `min_radius = 1`.
- feng - computes B if only A is given. Computes [B, z] if also y is given as a second parameter.
- generateLegend - makes a custom legend for the active figure.
- get_in_degree - computes a vector in which each component is the in-degree of each row of the graph. The matrix Q has to be an adjacenct matrix for the graph in question.
- getPath - generates predefined path given an input number. The path is a matrix that has 2 columns (x and y) and as many rows as points in the path.
- init_A - coincide with the training step. It computes A given the sensors' positions
- init_Q - computes a suitable wheighted matrix for the graph, given the sensors' positions. It uses uniform weights (to garantuee consensus) and checks whether the given $\epsilon$ belogs to the permitted interval.
- plotAgents - plots the agents inside a room given the sensors' positions. It can display the radius of the sensors, can display the sensors with random colors and can display the sensors using their ID.
- plotPath - uses arrow.m for plotting a path in the room
- pos2cell - converts a position (x,y) to the corresponding cell index.
- showRoom - creates a new figure and display the number of each cell.

## Restults and Analysis

intro - anche no

### experiment A
description

#### Risultati

### Experiment B 
descrption
#### Risultati

### Experiment C 

The objective of this experiment is to verify the relationship between the essential spectral radius of the matrix Q and the convergence time of the system.
The setup for this experiment is the following:

- random sensor positions
- 30 rounds for each sensor deployment with varying essential spectral radius manipulating $\epsilon$ between 0.2 and 0.8 the maximum permitted value
- 
#### Results


## Extensions (Se ne facciamo)
etc...
