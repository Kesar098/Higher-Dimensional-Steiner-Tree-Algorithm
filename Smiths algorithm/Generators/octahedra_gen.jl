@inline function octahedra(d::Int)
    vertices = Vector{Vector{Float64}}()
    n::Int = d+d
    for i in 1:n
        vertex = zeros(Float64, d)
        if (i<=d)
            vertex[i] = 1.0
            push!(vertices, vertex)
        else
            vertex[i-d] = -1.0
            push!(vertices, vertex)
        end

    end

    return vertices
end