

include("./Ordering/Ordering.jl")
include("./Initialise_Structs.jl")

include("./FermatPoint.jl")
include("./three.jl")
include("./UpperBound/Upperbound.jl")

include("./node.jl")
include("./FasterPriorityQueues/heap.jl")
include("./BuildTree.jl")
include("./Error.jl")
include("./LengthTree.jl")

include("./Optimise.jl")

include("./Enum_Scheme.jl")

function Smiths(T::Vector{Vector{Float64}})
    start = time()

    ### Preprocessing: Ordering Terminals ###
    #T = dist_Centroid(T)
    T = FurtherestSite(T)

    ### Setup up structs to hold data and the arrays used for optimiser###
    data, OA = Initialise(T)

    mstlen::Float64 = MST(0,data,OA)
    upperbound::Float64 = 0.0
    
    if (N!=3)
        if (D>=5)
            upperbound = GreedyUpperbound(data, OA)
        else
            upperbound = Shortestangheuristic(data, OA)
            #upperbound = SpanningTreeRelax(data, OA)
        end
    end

    finish = time()
    tt = finish-start
    println("Preprocessing Complete: $tt seconds.")
    println("Upperbound = ",upperbound)

    ### Main Process ###
    # Special Case for 3 terminals
    if (N == 3)
        println("Main Process Started!")
        start = time()
        len, data = three(data)
        finish = time()
        tt = finish-start
        print_time(tt)

        return len, mstlen, data, OA
    end


    #### Smith's Enumeration Scheme ####
    bestnode, len = enumerate(upperbound, data, OA)


    getAdj(bestnode, data)
    temp = optimise(bestnode.level + 1, data, OA)
    
    return len, mstlen, data, OA
end