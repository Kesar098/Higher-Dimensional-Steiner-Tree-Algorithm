function getAdjacencies2(data::Variables)
    edges = data.edges

    mst_adjmatrix = Vector{Int}[Int[] for _ in 1:N+N-2]

    for i in 1:(N-1)
        e1 = edges[i,1]
        e2 = edges[i,2]

        push!(mst_adjmatrix[e1],e2)
        push!(mst_adjmatrix[e2],e1)
    end
    return mst_adjmatrix
end

function localRMT(A::T, B::T, C::T)::Float64 where {T<:AbstractVector}
    S = similar(A)
    S = fermat(A, B, C)
    return dist(A,S) + dist(B,S) + dist(C,S)
end

function findshortestangle(mst_adjmatrix::AbstractVector, data::Variables)
    V = data.Vertices

    shortestang::Float64 = Inf
    combinedDist::Float64 = 0
    ter::Int = 0 
    n1::Int = 0
    n2::Int = 0

    for t in 1:N
        if length(mst_adjmatrix[t]) > 1
            for i in eachindex(mst_adjmatrix[t])
                a = mst_adjmatrix[t][i]
                for j in eachindex(mst_adjmatrix[t])
                    b = mst_adjmatrix[t][j]
                    if a != b 
                        ang = angle(V[t],V[a],V[b])
                        #=println("ang = ",ang)
                        println("t = ",t)
                        println("a = ",a)
                        println("b = ",b)=#
                        
                        if (ang < shortestang) 
                            shortestang = ang
                            ter = t
                            n1 = a
                            n2 = b
                        end
                    end
                end
            end
        end
    end
    return shortestang, ter, n1, n2
end

function Shortestangheuristic(data::Variables, OA::optiArrays)
    V = data.Vertices

    # Find MST
    len = MST(0,data,OA) 

    # Get degree for each terminal in MST
    mst_adjmatrix = getAdjacencies2(data)

    K = 0 #number of Steiner points added
    while K<N-2
        #println(mst_adjmatrix)
        shortestang, ter, n1, n2 = findshortestangle(mst_adjmatrix, data)
        #=println("ang = ",shortestang)
        println("ter = ",ter)
        println("n1 = ",n1)
        println("n2 = ",n2)=#

        
        #=if shortestang >=  (2*pi)/3
            #display(mst_adjmatrix)
            #throw("fail")
            break
        end=#

        K+=1
        nextstp = N+K

        a = popat!(mst_adjmatrix[ter], findfirst(x -> x === n1, mst_adjmatrix[ter]))
        b = popat!(mst_adjmatrix[ter], findfirst(x -> x === n2, mst_adjmatrix[ter]))
        push!(mst_adjmatrix[ter],nextstp)
    
        deleteat!(mst_adjmatrix[a], findfirst(x -> x===ter,mst_adjmatrix[a]))
        deleteat!(mst_adjmatrix[b], findfirst(x -> x===ter,mst_adjmatrix[b]))
    
        push!(mst_adjmatrix[a],nextstp)
        push!(mst_adjmatrix[b],nextstp)
    
        push!(mst_adjmatrix[nextstp],ter)
        push!(mst_adjmatrix[nextstp],a)
        push!(mst_adjmatrix[nextstp],b)

        V[nextstp] .= fermat(V[ter],V[a],V[b]) .+ tol
        
    end

    #println(mst_adjmatrix)
    
    for i in (N+1):(N+K)
        data.adj[i-N,1] = mst_adjmatrix[i][1]
        data.adj[i-N,2] = mst_adjmatrix[i][2] 
        data.adj[i-N,3] = mst_adjmatrix[i][3] 
    end

    #display(data.adj)
    setInitialState(K, data, OA)
    len = optimise(K, data, OA)

    # Bottleneck property 
    return len + tol
end