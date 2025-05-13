function findvalue(value::T, A::AbstractArray{T}) where {T<:Real}
    for i in eachindex(A)
        if A[i] == value
            return i 
        end
    end
    return length(A)
end