function GreedyUpperbound(data::Variables, OA::optiArrays)

    currentNode = node{Int64}()
    Bestedge::Int = 0

    for _ in 1:N-3 

        Build_Subtree(currentNode, data)
        K = currentNode.level + 2
        children = 2*(currentNode.level) + 3
        Bestlen::Float64 = Inf

        for edge in 1:children
            SplitEdge(edge, currentNode.level, data)
            setInitialState(K, data, OA)
            len = optimise(K, data, OA)
            if (len < Bestlen)
                Bestlen = len
                Bestedge = edge
            end
        end
        
        if (K == N-2)
            return Bestlen + tol
        else 
            currentNode = node{Int64}(Bestedge, currentNode)
        end
    end
end