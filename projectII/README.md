20220624132035# Distribuited control of a multi-agents magnetic levitation system
> matlab/simulink implementation.

The simulink system is as follows.

![[simulink_main.png]]

Each section has a name. We are going to briefly explain each of them.

# Sections
## Leader
![[leader_outside.png]]

The subsystem leader contains the actual plant, which implements the dymanics of the magnetic levitator (maglev) and an observer, used for controlling the system with the pole-placement method.

![[leader_main.png]]

## Agents

The agents section contains all of the agents. The connection between components is made using the goto/from blocks. 

![[agents_outside.png]]

Each agent is an instance of another file, which allows to modify the system once for all the implementations.

![[agent_main.png]]

The file contains the stable system (which is an exact copy of the leader, including the observer) and an external observer which estimate the controlled state.

## epsilon_computation and zeta_computation

These two section implements the functions for calculating $\epsilon$ and $\zeta$ as explained by the theory.

![[epsilon_computation_outside.png]]

![[zeta_computation_outside.png]]

These blocks use the `matlab function` block to compute the necessary informations.

## To workspace
The last section only contains blocks whose purpose is to output data to the workspace for the analisys to take place.

# Files
The most important file is `stable_template.m` which is the skeleton of each configuration.
We shall briefly describe its steps:
1. First define the platnt parameters.
2. Defin initial conditions.
3. Design a pole-placement controller depeding on the reference command we want to impose.
4. Graph definition. Since we needed to make different graphs, we came up with a file function `generate_adj_matrix` which returns the adjacency matrix and the pinning vector.
5. Then it defines some variables which are used in the simulink files, we'll discuss that later
6. Agents' controller design using the Algebraic Riccati Equation and defining the decoupling constant c
7. Agents' observer design, following the same principle,
8. time definition for the simulation to take place and finally the simulation issue command.

## standard_model_variables
This file contains a function which has the purpose to assign some variable (used in the simulink) in the base workspace. The variables are:
- output_state, whether the state of the plant is measurable (always false, deprecated)
- eps_on, whether to compute $\epsilon$ (always true, deprecated)
- zeta_on, whther to compute $\zeta$. This comes in handy when using the local observer, thus speeding up the simulation
- measurement_noise_type, this variable decied whether there is noise on the measured output and if so, what type of noise it is.
- local_or_neighborhood_observer, does exactly what it sounds like.