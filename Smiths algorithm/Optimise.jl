include("./SetInitialState.jl")
include("./Optimiser_sub.jl")
include("./SOR.jl")


function optimise(K::Integer, data::Variables, OA::optiArrays)
    len = lengthTree(K, data)
    error = Error(K, data)  
    iter = 0
    while (error > len * tol)
        error1 = error
        #Optimiser_sub((tol*error/N), K, data, OA)
        SOR((tol*error/N), K, data, OA)
        len = lengthTree(K, data)
        error = Error(K, data)
        iter +=1
    end

    return len
end


function Preoptimise(pretol::Float64, K::Integer, data::Variables, OA::optiArrays)
    len = lengthTree(K, data)
    error = Error(K, data)  
    iter = 0
    while (error > len * (pretol)) 
        error1 = error
        #Optimiser_sub((tol*error/N), K, data, OA)
        SOR((tol*error/N), K, data, OA)
        len = lengthTree(K, data)
        error = Error(K, data)
        iter +=1
    end

    return (len - error)
end


