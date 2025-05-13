"""
Computes the fermat point using barycentric coordinates.

"""

const theta = (2*pi)/3
const alpha = pi/3

function fermat(A::T, B::T, C::T) where {T<:AbstractVector}

    A_t::Float64 = angle(A,B,C)
    if (A_t >= theta) || isnan(A_t)
        return A
    end

    B_t::Float64 = angle(B,A,C)
    if (B_t >= theta) || isnan(B_t)
        return B
    end

    C_t::Float64 = angle(C,A,B)
    if (C_t >= theta) || isnan(C_t)
        return C
    end

    a::Float64 = A_t .+ alpha
    b::Float64 = B_t .+ alpha
    c::Float64 = C_t .+ alpha

    a = sin(A_t)./sin(a)
    b = sin(B_t)./sin(b)
    c = sin(C_t)./sin(c)
    
    return ((a .* A) .+ (b .* B) .+ (c .* C)) ./ (a .+ b .+ c)
end