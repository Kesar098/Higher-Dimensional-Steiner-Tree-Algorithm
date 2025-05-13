
@inbounds function lengthTree(K::Int, data::Variables)::Float64
    V = data.Vertices
    adj = data.adj 
    EL = data.EL

    t::Float64 = 0.0
    len::Float64 =  0.0
    a::Int = 0
    b::Int = 0

    for i in 1:K
        n1 = adj[i,1]
        n2 = adj[i,2]
        n3 = adj[i,3]

        s = N + i

        #n1 
        if (n1<s)
            t = dist(V[s], V[n1]) #norm(V[s] .- V[n1]) 
            EL[i,1] = t
            len += t #(n1 < s ? t : 0.0)

            a = n1-N 
            if (a>0)
                b = findvalue(s,adj[a,:]) #findfirst(x -> x === s, adj[a,:])
                EL[a,b] = t
            end
        end

    
        #n2
        if (n2<s)
            t = dist(V[s], V[n2]) #norm(V[s] .- V[n2]) 
            EL[i,2] = t
            len += t #(n2 < s ? t : 0.0)

            a = n2-N 
            if (a>0)
                b = findvalue(s,adj[a,:]) #findfirst(x -> x === s, adj[a,:])
                EL[a,b] = t
            end
        end

        #n3
        if (n3<s)
            t = dist(V[s], V[n3]) #norm(V[s] .- V[n3]) 
            EL[i,3] = t
            len += t #(n3 < s ? t : 0.0)

            a = n3-N  
            if (a>0)
                b = findvalue(s,adj[a,:]) #findfirst(x -> x === s, adj[a,:])
                EL[a,b] = t
            end
        end
    end

    return len
end


