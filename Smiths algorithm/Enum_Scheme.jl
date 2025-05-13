"""
Smiths enumeration scheme implemeneted with a priority queue

"""


@inbounds function enumerate(upperbound::Float64, data::Variables, OA::optiArrays)

    println("Main Process Started!")
    start = time()
    # Assign priority queue
    pq =  HeapPriorityQueue{node{Int64}, Float64}()
    BestNode = node{Int64}()
    len::Float64 = 0.0
    enqueue!(pq,BestNode,len)

    while !isempty(pq) 

        currentNode = dequeue!(pq)
        Build_Subtree(currentNode, data)
        K = currentNode.level + 2  # Steiner point 
        children = 2*(currentNode.level) + 3

        for edge in 1:children
            SplitEdge(edge, currentNode.level, data)
            setInitialState(K, data, OA)

            # Pre-Optimisation
            len = Preoptimise(tol*5, K, data, OA)
            #len = Preoptimise(0.1, K, data, OA)
        
            if (len < upperbound)

                # Logs evaluated nodes
                data.evaluatednodes[currentNode.level+1]+=1
                if (K == N-2)
                    # Main Optimisation
                    len = optimise(K, data, OA)
                    if (len < upperbound)
                        upperbound = len 
                        BestNode = node{Int64}(edge, currentNode)
                        println("New Record Length = ", len)
                    else
                        # Logs pruned nodes
                        data.prunednodes[currentNode.level+1]+=1
                    end

                else 
                    child = node{Int64}(edge, currentNode)
                    enqueue!(pq, child, len)
                end

            else
                # Logs pruned nodes
                data.prunednodes[currentNode.level+1]+=1
            end
        end

    end

    finish = time()
    tt = finish-start
    print_time(tt)

    return BestNode, upperbound
end