
@inbounds function Error(K::Int, data::Variables)::Float64

    V = data.Vertices 
    adj = data.adj 
    EL = data.EL

    error::Float64 = 0.0 
    a = similar(V[1])
    b = similar(V[1])
    c = similar(V[1])

    for i in 1:K
        s = N .+ i
        n1::Int = adj[i,1]
        n2::Int = adj[i,2]
        n3::Int = adj[i,3]

        a .= V[n1] .- V[s]
        b .= V[n2] .- V[s]
        c .= V[n3] .- V[s]

        d12::Float64 = dot(a,b)
        d13::Float64 = dot(a,c)
        d23::Float64 = dot(b,c)

        el1::Float64 = EL[i,1]
        el2::Float64 = EL[i,2]
        el3::Float64 = EL[i,3]

        d12 = (d12 .+ d12) .+ (el1 .* el2)
        d13 = (d13 .+ d13) .+ (el1 .* el3)
        d23 = (d23 .+ d23) .+ (el2 .* el3)

        d12 = (d12 > 0.0 ? d12 : 0.0)
        d13 = (d13 > 0.0 ? d13 : 0.0)
        d23 = (d23 > 0.0 ? d23 : 0.0)
        
        error += d12 + d13 + d23
    end

    error = sqrt(error)
    return error
end
