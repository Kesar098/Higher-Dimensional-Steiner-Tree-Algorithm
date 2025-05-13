@inline function fastangle(a::M,b::M,c::M) where {M<:AbstractVector{T}} where {T}
    # Fast but inaccurate for small angles
    u  = (a.-b)
    v  = (a.-c)
    p = acos(dot(u,v)./(norm(u) .* norm(v)))
    return p
end


@inline function angle(a::M,b::M,c::M) where {M<:AbstractVector{T}} where {T}
    # Accurate but slow
    p  = (a.-b) ./ sqrt(foldl(+, abs2.(a.-b)))
    q  = (a.-c) ./ sqrt(foldl(+, abs2.(a.-c)))
    ang::Float64 = 2 .* atan(sqrt(foldl(+, abs2.(p.-q))), sqrt(foldl(+, abs2.(p.+q))))

    return !(signbit(ang) || signbit(float(T)(pi) - ang)) ? ang : (signbit(ang) ? zero(T) : float(T)(pi))
end