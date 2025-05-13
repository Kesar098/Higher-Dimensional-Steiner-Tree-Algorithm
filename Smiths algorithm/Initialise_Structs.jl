"""
These structs hold all the data structures used throughtout the running of the algorithm.
"""

struct Variables{T1<:Float64,T2<:Integer}
    Vertices::Vector{MVector{D, T1}}
    EL::MMatrix{N-2, 3, T1, 3*(N-2)}
    adj::MMatrix{N-2, 3, T2, 3*(N-2)}
    edges::MMatrix{N+N-3, 2, T2, 2*(N+N-3)}
    kVector::MVector{N-3, T2}
    prunednodes::Vector{BigInt}
    evaluatednodes::Vector{BigInt}
end


Base.@kwdef struct optiArrays{T1<:Float64,T2<:Integer}
    B::MMatrix{N-2, 3, T1, 3*(N-2)} = MMatrix{N-2, 3, T1, 3*(N-2)}(0.0 for _ in 1:(N-2), _ in 1:3)
    C::MMatrix{N-2, D, T1, D*(N-2)} = MMatrix{N-2, D, T1, D*(N-2)}(0.0 for _ in 1:(N-2), _ in 1:D)
    distmx::MMatrix{N+N-2, N+N-2, T1, (N+N-2)*(N+N-2)} = MMatrix{N+N-2, N+N-2, T1, (N+N-2)*(N+N-2)}(0.0 for _ in 1:N+N-2, _ in 1:N+N-2)
    eqnstack::MVector{N, T2} = MVector{N, T2}(0 for _ in 1:N)
    leafQ::MVector{N, T2} = MVector{N, T2}(0 for _ in 1:N)
    val::MVector{N-2, T2} = MVector{N-2, T2}(0 for _ in 1:(N-2))
    oldV::Vector{MVector{D, T1}} =  MVector{D,Float64}[MVector{D, T1}(0.0 for _ in 1:D) for _ in 1:N-2]
    wvec::MVector{N-2, T1} = MVector{N-2, T1}(1.0 for _ in 1:(N-2))
end

function Initialise(T::Vector{Vector{Float64}})
    
    V = MVector{D,Float64}[]
    for i in 1:N
        push!(V,MVector{D,Float64}(T[i]))
    end

    for i in 1:N-2
        push!(V,MVector{D,Float64}(T[i].+ 0.001))
    end

    a = N-2
    b = N+N-3

    EL = MMatrix{a, 3, Float64}(0.0 for x in 1:a, _ in 1:3)
    adj = MMatrix{a, 3, Int}(0 for _ in 1:a, _ in 1:3)
    edges = MMatrix{b, 2, Int}(0 for _ in 1:b, _ in 1:2)
    kVector = MVector{a-1, Int}(0 for _ in 1:a-1)
    prunednodes = BigInt[0 for _ in 1:a-1]
    evaluatednodes = BigInt[0 for _ in 1:a-1]

    data = Variables(V, EL, adj, edges, kVector,prunednodes,evaluatednodes)
    OA = optiArrays{Float64,Int}()
    return data, OA
end


