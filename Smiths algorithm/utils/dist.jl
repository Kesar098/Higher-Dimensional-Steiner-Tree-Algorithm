@inline function dist(p::M,q::M) where {M<:Union{MVector{T},SVector{T},Vector{T}}} where {T}
    x::Float64 = 0.0
    @inbounds @simd for i in eachindex(p) 
        x += (p[i] - q[i])^2
    end
    x = sqrt(x)
    return x
end