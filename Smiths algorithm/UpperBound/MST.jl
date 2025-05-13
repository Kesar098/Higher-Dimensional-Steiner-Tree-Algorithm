include("./Kruskals.jl")
include("./Prims.jl")

@inbounds function MST(I::Int, data::Variables, OA::optiArrays)

    if I==0
        return Prims(data.Vertices, data.edges, OA.distmx)
    else
        return Kruskals(data.Vertices, data.edges)
    end
    return nothing
end