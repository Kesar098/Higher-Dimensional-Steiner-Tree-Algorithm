"""
An implementation of Fonseca et. al ordering.
"""

function firstThree(T::Vector{Vector{Float64}})

    order = Int[0 for _ in 1:N]
    maxDist::Float64 = 0

    # Find three sites furthest apart and put them in order[1:3]
    for i in 1:N 
        for j in i+1:N
            dij = dist(T[i],T[j])
            for k in j+1:N
               dik = dist(T[i],T[k])
               djk = dist(T[j],T[k]) 

               m = dij+dik+djk
               if (m > maxDist)
                    maxDist = m
                    order[1] = i 
                    order[2] = j
                    order[3] = k 
               end
            end
        end
    end
    return order
end

function remaining(T::Vector{Vector{Float64}}, order::Vector{Int})

    remaining = Int[x for x in 1:N] 
    added = Int[]

    maxDist::Float64 = 0.0
    maxR::Int = 0

    for i in 1:3
        push!(added,order[i])
        deleteat!(remaining,findfirst(x -> x===order[i], remaining))
    end

    for i in 4:N
        maxDist = 0.0
        maxR = 0

        for r in remaining
            for a in added
                d::Float64 = dist(T[r],T[a])

                if (d > maxDist)
                    maxDist = d
                    maxR = r
                end
            end
        end

        push!(added, maxR)
        deleteat!(remaining, findfirst(x -> x===maxR, remaining))
        order[i] = maxR
        
    end
    
    return order
end

function FurtherestSite(T::Vector{Vector{Float64}})

    order = firstThree(T)
    order = remaining(T,order)
    
    temp = similar(T)

    for i in eachindex(order)
        temp[i] = T[order[i]]
    end

    return temp
end