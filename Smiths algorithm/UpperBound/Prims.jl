function Compute_distmx(V::Vector{MVector{N1,Float64}}, distmx::AbstractArray{Float64}) where {N1}
    # Initialize the distance matrix
    for i in 1:N
        for j in 1:N
            if i != j
                distmx[i, j] = norm(V[i] .- V[j])
            else
                distmx[i, j] = Inf
            end
        end
    end
end

# Prims algorithm
function Prims(V::Vector{MVector{N1,Float64}}, edges::AbstractArray{Int}, distmx::AbstractArray{Float64}) where {N1}
    Compute_distmx(V,distmx)
    selected = MVector{N, Bool}(false for _ in 1:N)
    selected[1] = true
    len::Float64 = 0.0

    k = 0
    for _ in 1:(N)
        min_dist::Float64 = Inf
        u = -1
        v = -1

        for i in 1:N
            if selected[i]
                for j in 1:N
                    if !selected[j] && distmx[i, j] < min_dist
                        min_dist = distmx[i, j]
                        u = i
                        v = j
                    end
                end
            end
        end

        if u != -1 && v != -1
            k+=1
            edges[k,1] = u
            edges[k,2] = v
            len += min_dist
            selected[v] = true
        end
    end
    return len
end