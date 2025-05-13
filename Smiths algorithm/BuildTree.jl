"""
Build_Subtree(): Creates the edge set corresponding to the tree for the current node using the topology describing vector kVector.
SplitEdge(): Creates the Adjancey matrix corresponding to the edge set for the subtree with the current edge split using the sprout operation.

"""

@inbounds function Build_Subtree(CN::node, data::Variables)
    edges = data.edges
    kVector = data.kVector
    
    L::Int = CN.level
    stp::Int = N + 1

    # Unroll kVector
    for _ in 1:L
        kVector[CN.level] = CN.edgeSplit
        CN = CN.parent
    end

    # Build edge set
    edges[1,1], edges[1,2] = 1, stp
    edges[2,1], edges[2,2] = 2, stp
    edges[3,1], edges[3,2] = 3, stp

    e::Int = 3

    for i in 1:L

        es::Int = kVector[i]
        stp::Int +=1
        e2::Int = edges[es, 2]

        edges[es, 2] = stp
        
        e+=1
        edges[e,1] = e2
        edges[e,2] = stp

        e+=1
        edges[e,1] = i + 3
        edges[e,2] = stp
    end

    return nothing
end


@inbounds function SplitEdge(e::Integer, Level::Integer, data::Variables)

    adj = data.adj
    edges = data.edges

    g::Int = 2 * Level + 3
    newTer::Int = Level + 4
    newStp::Int = Level + 2

    fill!(adj,0)

    # Build Adjancey matrix 
    for i in 1:g

        ea::Int = edges[i,1]
        e1::Int = ea - N
        
        eb = (i === e ? newStp + N : edges[i,2])
        e2 = (i === e ? newStp : edges[i,2] - N)

        if (e1>=1)
            a = findfirst(x -> x === 0, adj[e1, :])
            adj[e1, a] = eb
        end

        if (e2>=1)
            a = findfirst(x -> x === 0, adj[e2, :])
            adj[e2, a] = ea
        end
    end

    # add two new edges to adj
    e1 = edges[e,2] .- N
    adj[e1, 3] = newStp .+ N
    adj[newStp, 2] = edges[e,2]     
    adj[newStp, 3] = newTer

    return nothing
end
