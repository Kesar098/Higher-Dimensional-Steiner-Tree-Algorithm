using StaticArrays
using LinearAlgebra
using Random
#Random.seed!(999)

global const N = 4
global const D = 3
global const tol = 10^(-4)

include("./utils/utils.jl")
include("./Generators/Generators.jl")
include("./Initialise_Structs.jl")
include("./node.jl")

include("./BuildTree.jl")
include("./Error.jl")
include("./LengthTree.jl")

include("./SetInitialState.jl")
include("./Optimise.jl")
include("./Optimiser_sub.jl")
include("./SOR.jl")

function mean(A::AbstractVector{T}) where {T<:Real}
    return sum(A)/length(A)
 end
 
function setup(T::Vector{Vector{Float64}})

    data, OA = Initialise(T)
    if N == 4
        data.adj[:] = [1 2 6; 3 5 4]
    elseif N==5
        data.adj[:] = [1 4 7; 2 6 8; 5 3 7]
    elseif N==6
        data.adj[:] = [1 2 10; 5 6 10; 3 4 10; 7 8 9]
    elseif N==7
        data.adj[:] = [10 11 12; 1 4 11; 2 8 5; 6 8 9; 3 7 8]
    elseif N==8
        data.adj[:] = [10 11 14; 2 4 9; 9 12 13; 5 6 11; 3 7 11; 1 8 9]
    elseif N==9
        data.adj[:] = [16 11 14; 3 10 4; 5 13 14; 2 12 6; 10 12 15; 7 14 8; 1 10 9]
    elseif N==10
        data.adj[:] = [12 13 14; 11 15 17; 11 16 18; 2 6 11; 4 7 12; 5 8 13; 3 9 12; 1 10 13]
    elseif N==11
        data.adj[:] = [2 3 13; 12 15 20; 15 17 18; 13 14 16; 7 14 19; 4 8 14; 5 9 14; 6 10 16; 1 11 13]
    elseif N==12
        data.adj[:] = [14 19 22; 13 15 16; 14 20 21; 14 17 18; 6 7 16; 3 8 16; 2 9 13; 5 10 15; 4 11 15; 1 12 13]
    else
        throw("adj error")
    end
    
    return data, OA
end

function optimise(K::Int, data::Variables, OA::optiArrays)
    len::Float64 = lengthTree(K, data)
    error::Float64 = Error(K, data)
    iter = 0
    max_iter = 10000
    while (error > len * tol) #&& iter< max_iter
        Optimiser_sub((tol)*(error/N), K, data, OA)
        len = lengthTree(K, data)
        error = Error(K, data)
        iter +=1
    end
    #=if iter >= max_iter
        println("possible diverge iter_Phys = ",iter)
        println(data.Vertices)
        throw("error")
    end=#
    return iter, len
end

function Phys1(K::Int, data::Variables, OA::optiArrays)
    len::Float64 = lengthTree(K, data)
    error::Float64 = Error(K, data)
    iter = 0
    w = 1.2
    #len2 = len+len
    max_iter = 100000
    
    while (error > len * tol) #&& iter< max_iter # (len2-len)/len > tol
        #len2 = len 
        scale = (tol)*(error/N)
        SOR(w, scale, K, data, OA)
        len = lengthTree(K, data)
        error = Error(K, data)
        iter+=1
    end
    
    if iter >= max_iter
        println("possible diverge iter_Phys = ",iter)
        println(data.Vertices)
        throw("error")
    end

    return iter, len
end


function Phys2(K::Int, data::Variables, OA::optiArrays)
    len::Float64 = lengthTree(K, data)
    error::Float64 = Error(K, data)
    iter = 0
    w = 1.9
    #len2 = len+len
    max_iter = 100000
    
    while (error > len * tol)
        scale = (tol)*(error/N)
        SOR(w, scale, K, data, OA)
        len = lengthTree(K, data)
        error = Error(K, data)
        iter+=1
    end
    
    #=if iter >= max_iter
        println("possible diverge iter_Phys = ",iter)
        println(data.Vertices)
        throw("error")
    end=#

    return iter, len
end

function Optitest()
    println("tol = ", tol)

    original_iterations = Int[]
    original_time = Float64[]
    Physics1_iterations = Int[]
    Physics1_time = Float64[]
    Physics2_iterations = Int[]
    Physics2_time = Float64[]

    K = N-2

    samples = 1

    for i in 1:samples
        T = randHyper(N,D)
        #T = [[2.9, 2.68], [1.16, 2.83], [2.56, 2.32], [1.75, 1.73]]
        #T = [[2.21, 2.91], [1.28, 1.38], [1.94, 1.72], [1.65, 1.02]]
        #T = [[0.81469, 0.20871], [0.46776, 0.71305], [0.68282, 0.31234], [0.77059, 0.23524]]
        #T = [[2.55, 2.94, 2.22], [2.63, 1.22, 2.61], [2.95, 2.13, 2.15], [2.65, 2.72, 1.96]]
        T = [[1.51, 2.52, 2.27], [2.62, 3.0, 2.92], [1.03, 1.85, 2.38], [2.87, 1.55, 1.0]]
        println(T)

        data, OA = setup(T)

        setInitialState(K, data, OA)

        data2 = deepcopy(data)
        OA2 = deepcopy(OA)

        data3 = deepcopy(data)
        OA3 = deepcopy(OA)

        start = time()
        original,len = optimise(K,data,OA)
        finish = time()
        ot = finish-start

        start = time()
        phys1, len2 = Phys1(K,data2,OA2)
        finish = time()
        pt1 = finish-start

        start = time()
        phys2, len3 = Phys2(K,data3,OA3)
        finish = time()
        pt2 = finish-start

        #println("original = ", len)
        #println("Stable Physics = ", len2)
        #println("Stable Physics2 = ", len3)

        push!(original_iterations, original)
        push!(original_time, ot)
        push!(Physics1_iterations, phys1)
        push!(Physics1_time, pt1)
        push!(Physics2_iterations, phys2)
        push!(Physics2_time, pt2)

    end
    
    return original_iterations, original_time, Physics1_iterations, Physics1_time, Physics2_iterations, Physics2_time
end


function test()
    oiter, otime, p1iter, p1time, p2iter, p2time = Optitest()
    println(length(oiter))

    println("Original:")
    println("Average iterations for $N = ", mean(oiter))
    println("Average time for $N = ", mean(otime))

    println("Stable Physics:")
    println("Average iterations for $N = ", mean(p1iter))
    println("Average time for $N = ", mean(p1time))

    println("Stable Physics:")
    println("Average iterations for $N = ", mean(p2iter))
    println("Average time for $N = ", mean(p2time))

end

test()