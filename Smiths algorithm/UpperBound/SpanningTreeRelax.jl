function getAdjacencies(data::Variables)
    edges = data.edges

    mst_adj = Int[0 for i in 1:N]
    mst_adjmatrix = Vector{Int}[Int[] for _ in 1:N+N-2]

    for i in 1:(N-1)
        e1 = edges[i,1]
        e2 = edges[i,2]

        push!(mst_adjmatrix[e1],e2)
        push!(mst_adjmatrix[e2],e1)
    end

    return mst_adjmatrix
end

function STR(data::Variables, OA::optiArrays)::Float64
    # Find MST
    # Get degree for each terminal in MST
    mst_adjmatrix = getAdjacencies(data)
    # add c-1 Steiner points for each terminal with degree c>1
    k = 0 #number of Steiner points
    for i in 1:N
        if (length(mst_adjmatrix[i]) > 1)
            while (length(mst_adjmatrix[i]) > 1)
                k+=1
                nextstp = N+k
                a = popfirst!(mst_adjmatrix[i])
                b = popfirst!(mst_adjmatrix[i])
                push!(mst_adjmatrix[i],nextstp)

                deleteat!(mst_adjmatrix[a], findfirst(x -> x==i,mst_adjmatrix[a]))
                deleteat!(mst_adjmatrix[b], findfirst(x -> x==i,mst_adjmatrix[b]))

                push!(mst_adjmatrix[a],nextstp)
                push!(mst_adjmatrix[b],nextstp)

                push!(mst_adjmatrix[nextstp],i)
                push!(mst_adjmatrix[nextstp],a)
                push!(mst_adjmatrix[nextstp],b)
            end
        end
    end

    for i in (N+1):(N+N-2)
        data.adj[i-N,1] = mst_adjmatrix[i][1]
        data.adj[i-N,2] = mst_adjmatrix[i][2] 
        data.adj[i-N,3] = mst_adjmatrix[i][3] 
    end
    
    setInitialState(N-2, data, OA)
    len = optimise(N-2, data, OA)
    return len + tol
end

function SpanningTreeRelax(data::Variables, OA::optiArrays)
    
    fill!(data.edges,0)
    len = MST(0,data,OA)
    prims::Float64 = STR(data, OA)
    
    fill!(data.edges,0)
    fill!(data.adj,0)
    len = MST(1,data,OA)
    kruskal::Float64 = STR(data, OA)
    
    return min(prims,kruskal)
end