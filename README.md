# Algorithims for Higher Dimensional Steiner Trees

The Euclidean Steiner tree problem is to find a tree of minimal length interconnecting a given set of n points in a d-dimensional Euclidean space by the insertion of Steiner points.

This repository contains the code for Smith's algorithm [1] implemented in Julia v1.11 using a priority queue and Smith's numerical method is implemented using Successive Over-Relaxation. This algorithm expands on the work of Fonseca, Brazil, Winter and Zachariasen [2]. You can experiment with the intial sorting algorithm, the intial upper bound and the relaxation factor used for the numerical algorithm.


* [1] Warren D. Smith. “How to find Steiner minimal trees in Euclidean d-space”. In: Algorithmica 7.1–6 (June 1992), 

* [2] R. Fonseca, M. Brazil, P. Winter, and Martin Tvede Zachariasen. Faster Exact Algorithms for Computing Steiner Trees in Higher Dimensional Euclidean Spaces (2014).


# Usage
MAIN.jl is the file which the script can be run from. Number of Terminals N, Dimension D and tolerance tol must be set before each new run in the global const field below. Input must be a vector of vectors where all values are Float64.

The first run with a new N, D or tol will be slower than any subsequent runs. Changing the position of Input terminals does not affect the running time of the algorithm. 

Plotting only works for terminal sets of dimension 2 and 3.

      plot = [true | false]

The figures folder contains example plots for Tetrahedron, Octahedron, Cube, Icosahedron terminal sets.



### Instances
Tetrahedron, Octahedron, Cube, Icosahedron terminal sets are available by typing the name as the input.

    run(tetrahedron, plot=true)

### Generators

simplex(N): Generates the vertices of a N-1 simplex. Make sure N and D are the same before running.

octahedra(D): Generates the vertices of a D-octahedra. Make sure N is twice that of N. 

N_D(N,D): Generates random vertices corresponding to N and D.

    run(simplex(N), plot=false)



# Example Output
### Input:

    global const N = 5
    global const D = 5
    global const tol = 10^(-4)

    ...

    run(simplex(N), plot=false)

### Output:

    Terminals: 5
    Dimension: 5
    Tolerance: 0.0001
    Preprocessing Complete: 0.0 seconds.
    Upperbound = 4.4336491353175305
    Main Process Started!
    New Record Length = 4.433549135317532
    New Record Length = 4.433549135317531
    Time taken: 0.0 seconds

    Nodes Pruned at each level:
    Level 1: 0
    Level 2: 13

    Nodes Evaluated at each level:
    Level 1: 3
    Level 2: 15

    Terminals and Steiner Points:
    1: [1.0, 0.0, 0.0, 0.0, 0.0]
    2: [0.0, 1.0, 0.0, 0.0, 0.0]
    3: [0.0, 0.0, 1.0, 0.0, 0.0]
    4: [0.0, 0.0, 0.0, 1.0, 0.0]
    5: [0.0, 0.0, 0.0, 0.0, 1.0]
    6: [0.27757981792540454, 0.27757981792540454, 0.13113312112542025, 0.18257412189543654, 0.13113312112833386]
    7: [0.1854502194511356, 0.18545021945298806, 0.18545032239555959, 0.25819891630343117, 0.18545032239688544]
    8: [0.1311331338544894, 0.13113313385581205, 0.27757974566429683, 0.18257424096110467, 0.2775797456642968]

    Edges:
    1-6, 2-6, 3-8, 6-7, 4-7, 7-8, 5-8,

    Adjancey Matrix:
    6: [1, 2, 7]
    7: [6, 4, 8]
    8: [3, 7, 5]

    kVector = [3, 3]

    Length of tree (SMT) = 4.433549135317531

    MST = 5.656854249492381

    Steiner ratio = 0.7837481645766949
    END!
