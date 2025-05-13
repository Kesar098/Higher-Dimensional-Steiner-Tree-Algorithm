@inline function simplex(n::Int)
    V = Vector{Vector{Float64}}()
    identity = Array{Float64}(I,n,n)

    for i in 1:n 
        push!(V,identity[i,:])
    end
    return V
end

simplex(N) 