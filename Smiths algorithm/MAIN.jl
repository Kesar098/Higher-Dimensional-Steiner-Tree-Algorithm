using LinearAlgebra
using StaticArrays # Faster arrays and vectors 
using DataStructures # Backbone of priority queues
using Random
#Random.seed!(234)
using PyCall # Used for plotting alongside Plotly in python

# Package for tesing code performance
using BenchmarkTools 

"""
Usage:
Number of Terminals N, Dimension D and tolerance tol must be set before each new run in the global const field below.
Input must be a vector of vectors where all values are Float64.

Plotting:  plot = [true | false]

Example hexagaon: N=6 D=2
        Ter = [[0.5, sqrt(3)],[1.5, sqrt(3)],[2.0, sqrt(3)/2],[1.5, 0.0],[0.5, 0.0],[0.0, sqrt(3)/2]]

        run(Ter, plot=true)

Generators:
simplex(N): Generates the vertices of a N-1 simplex. Make sure N and D are the same before running.
octahedra(D): Generates the vertices of a D-octahedra. Make sure N is twice that of N. 
N_D(N,D): Generates random vertices corresponding to N and D.

Example Instances: 
tetrahedron, octahedron, cube, icosahedron terminal sets are available by typing the name as input.
    Example: run(tetrahedron, plot=true)


"""


##### MUST SET BEFORE EACH NEW RUN!!!! ######
global const N = 5
global const D = 5
global const tol = 10^(-4)


include("./utils/utils.jl")
include("./Generators/Generators.jl")
include("./Smiths_Algorithm.jl")
include("./Output.jl")
include("./plots/plots.jl")


function run(T::Vector{Vector{Float64}}; plot::Bool = false)

    # Check Input for issues
    InputValidation(T)
    println("Terminals: ",N)
    println("Dimension: ",D)
    println("Tolerance: ",tol)

    # Runs Smiths Algorithm
    len, mstlen, data, OA = Smiths(T)
    output(len, mstlen, data, OA)

    # Plotting
    if (D==2) && (plot==true)
        plot2D(N, len, data)

    elseif (D==3) && (plot==true)
        plot3D(N, len, data)
    end
    println("END!")
    return nothing
end


run(simplex(N), plot=false)