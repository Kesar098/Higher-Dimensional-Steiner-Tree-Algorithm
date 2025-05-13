function randHyper(N::Int, D::Int)
    T = [(2 * rand(D) .+ 1) for _ in 1:N]

    for i in 1:N 
        T[i] .= round.(T[i]; digits = 2)
    end

    return T
end

