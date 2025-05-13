function ComputeEdgeList(V::Vector{MVector{N1,Float64}}) where {N1}
    distList = Float64[]
    edgeslist = Vector{Int}[Int[],Int[]]
    
    # Initialize the distance matrix
    for i in 1:(N)
        for j in i+1:(N)
             push!(distList, norm(V[i] .- V[j]))
             push!(edgeslist[1], i)
             push!(edgeslist[2], j)
        end
    end

    sorted_indices = sortperm(distList)
    distList = distList[sorted_indices]
    edgeslist[1] = edgeslist[1][sorted_indices]
    edgeslist[2] = edgeslist[2][sorted_indices]

    return distList, edgeslist
end

function connect(u::Int,v::Int,A::Vector{Int})
    a = A[u]
    b = A[v]

    if a==b
        return nothing

    elseif (a>b)
        a,b = b,a
    end

    for i in eachindex(A)
        if A[i] == b
            A[i] = a
        end
    end
end


function Kruskals(V::Vector{MVector{N1,Float64}}, edges::AbstractArray{Int}) where {N1}

    distList, sorted_edges  = ComputeEdgeList(V)
    Components = Int[i for i in 1:N]
    
    len::Float64 = 0.0
    i::Int = 0

    while (sum(Components) != N)
        u = popfirst!(sorted_edges[1])
        v = popfirst!(sorted_edges[2])
        temp = popfirst!(distList)

        if Components[u] != Components[v]
            len += temp
            i+=1
            edges[i,1] = u
            edges[i,2] = v
            connect(u,v,Components)
        end
        
    end

    return len
end