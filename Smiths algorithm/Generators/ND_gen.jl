@inline function N_D(n::Int, d::Int)
    V = Vector{Vector{Float64}}()
    for i in 1:n
        push!(V, rand(Float64, d))
    end
    return V
end