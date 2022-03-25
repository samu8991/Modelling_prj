# Algorithm
## Inizialization
1. Place the devices and determine the graph topology
2. Split the room in reference points
## Training phase
In this phase each device will measure quantity ([[RSS]] in this case) for each cell defined in the inizialization. These measuerments are the _fingerprint_ of the cell.
They are stored in a matrix A:
$$ A \in \mathbb{R}^{n,p} $$
Where each row of A correspond to the measurement of each fingerprint of each cell.
The matrix A takes the name of **dictionary**.
 ```ad-note
 There is an interesting scenario in which the matrix A becomes a tensor and the sensors take multiple measurements of the same position and the tensor has many rows as measurement taken $A \in \mathbb{R}^{nm, p}$ or $A \in \mathbb{R}^{m,n,p}$
 ```
## Runtime phase
In general the idea is as follows:
1. The target emits a signal
2. The [[WSN]] collaborate to localize the target trhough dictionary A.

The "collaboration" part is undefined till now and we underline that there are many ways the sensors can collaborate. Surely the [[distribuited algorithms]] are preferred, but also [[Nearest Neighbor (NN)]] are available.

---
# Pros and cons
<h3 style="color:red"> Cons </h3>
- The training phase is slow
- It requires lots of space
- If the space changes, everything has to be done from scratch
<h3 style="color:green"> Pros </h3>
+ This approach learns the physical environment
+ It's really accurate


