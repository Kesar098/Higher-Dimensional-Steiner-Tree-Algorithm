function getAdj(CN::node, data::Variables)
    #N = data.N

    es::Int = e1::Int = e2::Int = 0
    stp::Int = N + 1
    L::Int = CN.level
    g::Int = 2*(L)+3

    adj = data.adj
    edges = data.edges
    kVector = data.kVector

    while !isnothing(CN.parent)
        kVector[CN.level] = CN.edgeSplit
        CN = CN.parent

    end

    # Build edge matrix
    edges[1,1], edges[1,2] = 1, stp
    edges[2,1], edges[2,2] = 2, stp
    edges[3,1], edges[3,2] = 3, stp

    e = 3
    for i in 1:L

        es = kVector[i]
        stp = N + i + 1
        e2 = edges[es, 2]

        edges[es, 2] = stp
        
        e+=1
        edges[e,1] = e2
        edges[e,2] = stp

        e+=1
        edges[e,1] = i+3
        edges[e,2] = stp

    end

    #Build adjacency matrix
    fill!(adj,0)

    a::Int = 1
    for i in 1:g
        e1 = edges[i,1] .- N
        e2 = edges[i,2] .- N

        if (e1>=1)
            a = findvalue(0,adj[e1,:]) #findfirst(x -> x === 0, adj[e1, :])
            adj[e1, a] = edges[i,2]
        end

        if (e2>=1)
            a = findvalue(0,adj[e2,:]) #findfirst(x -> x === 0, adj[e2, :])
            adj[e2, a] = edges[i,1]
        end        
    end
    return nothing
end

function nodesPrunedEval(data::Variables)
    println("\nNodes Pruned at each level:")
    for i in 1:(N-3)
        println("Level $i: ", data.prunednodes[i])
    end

    println("\nNodes Evaluated at each level:")
    for i in 1:(N-3)
        println("Level $i: ", data.evaluatednodes[i])
    end
end


function output(len::Float64, mstlen::Float64, data::Variables, OA::optiArrays)
    V = data.Vertices
    adj = data.adj
    edges = data.edges

    if (N!=3) && (N<12)
        nodesPrunedEval(data::Variables)
    end

    # Print Vertices
    println("\nTerminals and Steiner Points: ")
    for i in 1:(N+N-2)
        println("$i: ", V[i])
    end

    #=println("\nTerminals and Steiner Points (rounded): ")
    for i in 1:(N+N-2)
        println("$i: ", round.(V[i],digits=5))
    end=#

    println("\nEdges:")
    for e in eachrow(edges)
        print(e[1], "-",e[2],", ")
    end
    println(" ")

    #Print adj, kVector and length
    if (N==3)
        println("\nAdjancey Matrix:")
        println("4: ", [1, 2, 3])

        println("\nkVector = Null",)
        println("\nLength of tree (SMT) = $len")
        #println("\nLength of tree (SMT) = $(round(len,digits = 8))")

    else
        println("\nAdjancey Matrix:")
        for i in 1:N-2
            s = i + N
            println("$s: ", adj[i,:])
        end
        
        println("\nkVector = ",data.kVector)
        println("\nLength of tree (SMT) = $len")
        #println("\nLength of tree (SMT) = $(round(len,digits = 8))")
    end

    #Steiner ratio 
        println("\nMST = $mstlen")
        ratio = len/mstlen
        println("\nSteiner ratio = $ratio")

    return nothing
end