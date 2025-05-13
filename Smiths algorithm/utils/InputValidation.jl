function InputValidation(T::Vector{Vector{Float64}})

    if size(T,1) != N 
        throw("Size of Terminals not equal to N! Make sure global const N is set correctly.")
    end

    if size(T[1],1) != D
        throw("Dimension of Terminals not equal to D! Make sure global const D is set correctly.")
    end

    if tol > 0.01
        throw("Tolerance is not below 0.01! Make sure global const tol is set correctly.")
    end

    #Check if all Terminals are the same
    count = 0
    for i in eachindex(T)
        if T[1] == T[i]
            count +=1
        end
    end

    if (count == N)
        throw("All points are the same")
    end
    return nothing
end