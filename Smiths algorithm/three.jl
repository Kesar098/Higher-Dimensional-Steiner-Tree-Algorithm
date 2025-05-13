
"""
Computes the Steiner point for 3 Terminals by finding the Fermat point .

"""

include("./FermatPoint.jl")


function three(data::Variables)

    A = data.Vertices[1]
    B = data.Vertices[2]
    C = data.Vertices[3]
    data.Vertices[4] .= fermat(A,B,C)
    S = data.Vertices[4]

    # build edge matrix
    data.edges[1,1] = 1
    data.edges[2,1] = 2
    data.edges[3,1] = 3
    data.edges[1,2] = data.edges[2,2] = data.edges[3,2] = 4

    len::Float64 = dist(A,S) + dist(B,S) + dist(C,S)

    return len, data
end