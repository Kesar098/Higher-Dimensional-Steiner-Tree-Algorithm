"""
Places the Steiner points in their initial postion before optimisation.

"""

@inbounds function setInitialState(K::Int, data::Variables, OA::optiArrays)
    #N = data.N
    #D = data.D
    V = data.Vertices
    adj = data.adj 
  
    V[N+1] .= (V[1] .+ V[2] .+ V[3]) ./3.0 .+ (0.001*rand())
    
    for i in 2:K
        n1 = adj[i,1]
        n2 = adj[i,2]
        n3 = adj[i,3]
        
        V[N+i] .= (V[n1] .+ V[n2] .+ V[n3]) ./3.0 .+ (0.001*rand())
        
    end
    return nothing
end

function centroid()
    
end
function setInitialState(K::Int, data::Variables, OA::optiArrays)

    
    return nothing
end

