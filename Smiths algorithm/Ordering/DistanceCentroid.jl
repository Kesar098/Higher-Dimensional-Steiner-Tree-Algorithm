"""
Orders the terminals based on their distance from the centroid.

"""

function dist_Centroid(T::Vector{Vector{Float64}})

    cen = Vector{Float64}(undef,D)

    for i in 1:N
        cen += T[i]
    end
    cen = cen./N

    sort!(T, rev = true, by = p -> dist(p, cen))

    return nothing
end