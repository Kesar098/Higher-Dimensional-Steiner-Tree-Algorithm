"""
Uses pycall and python ersion of plotly

"""

go = pyimport("plotly.graph_objects")


global red = "#D22B2B"
global blue = "#0050FF"
global green = "#008600"
global grey = "#3b3b3b"


function plot2D(N::Int, len::Float64, data::Variables)

    T = data.Vertices[1:N]
    V = data.Vertices
    SP = data.Vertices[N+1:end]
    E = data.edges

    fig = go.Figure()

    # Terminals
    x = Float64[]
    y = Float64[]
    Tertext = String[]
    for i in eachindex(T)
        push!(x, T[i][1])
        push!(y, T[i][2])
        push!(Tertext, "Terminal $i")
    end

    # Steiner points
    spx = Float64[]
    spy = Float64[]
    sptext = String[]
    for i in eachindex(SP)
        push!(spx, SP[i][1])
        push!(spy, SP[i][2])
        push!(sptext, "Steiner point $i")
    end

    # Edges
    for i in axes(E,1)
        fig[:add_trace](go.Scatter(x=[V[E[i,1]][1], V[E[i,2]][1]], 
                                   y=[V[E[i,1]][2], V[E[i,2]][2]], 
                                   mode="lines", line=Dict("width"=>2, "color"=>"black")))
    end

    # Plot
    config = Dict("staticPlot" => false)

    fig[:update_layout](title = "N = $N, Tree Length = $len",
                        showlegend=false, template="simple_white")

    fig[:add_trace](go.Scatter(x=x, y=y, text = Tertext, name="", 
                        mode="markers", 
                        marker=Dict("size"=>10, "color"=>blue, "line" =>Dict("width"=>2,"color"=>grey))))

    fig[:add_trace](go.Scatter(x=spx, y=spy, text= sptext, name = "", 
                                            mode="markers", 
                                            marker=Dict("size"=>10, "color"=>red, "line" =>Dict("width"=>2,"color"=>grey))))


    fig[:update_xaxes](showgrid=true, zeroline=true, zerolinewidth=2, zerolinecolor="lightgray")
    fig[:update_yaxes](showgrid=true, zeroline=true, zerolinewidth=2, zerolinecolor="lightgray", scaleanchor="x", scaleratio=1)
    fig[:show](config=config)
    
end

function plot3D(N::Int, len::Float64, data::Variables)

    T = data.Vertices[1:N]
    V = data.Vertices
    SP = data.Vertices[N+1:end]
    E = data.edges

    fig = go.Figure()
    # Vertices
    x = Float64[]
    y = Float64[]
    z = Float64[]
    Tertext = String[]

    for i in eachindex(T)
        push!(z, T[i][1])
        push!(x, T[i][2])
        push!(y, T[i][3])
        push!(Tertext, "Terminal $i")
    end

    # Steiner points
    spx = Float64[]
    spy = Float64[]
    spz = Float64[]
    sptext = String[]

    for i in eachindex(SP)
        push!(spz, SP[i][1])
        push!(spx, SP[i][2])
        push!(spy, SP[i][3])
        push!(sptext, "Steiner point $i")
    end

    # Edges
    for i in axes(E,1)
        fig[:add_trace](go.Scatter3d(x=[V[E[i,1]][2], V[E[i,2]][2]], 
                                    y=[V[E[i,1]][3], V[E[i,2]][3]], 
                                    z=[V[E[i,1]][1], V[E[i,2]][1]], 
                                    mode="lines", 
                                    line=Dict("color"=>"black", "width"=>3.5), 
                                    hoverinfo="skip"))
    end

    # Plot
    config = Dict("staticPlot" => false)

    fig[:add_trace](go.Scatter3d(x=x, y=y, z=z, text=Tertext, name="", 
                                                mode="markers", 
                                                marker=Dict("size"=>10, "color"=> blue),
                                                hovertemplate="%{text}: (%{z}, %{x}, %{y})"))

    fig[:add_trace](go.Scatter3d(x=spx, y=spy, z=spz, text=sptext, name="", 
                                                        mode="markers", 
                                                        marker=Dict("size"=>10, "color"=> red), 
                                                        hovertemplate="%{text}: (%{z}, %{x}, %{y})"))

                                                        
    # Outlines
    fig[:add_trace](go.Scatter3d(x=x, y=y, z=z, text=Tertext, name="", 
                                                        mode="markers", 
                                                        marker=Dict("size"=>10, "color"=>grey,"symbol"=>"circle-open"),
                                                        hovertemplate="%{text}: (%{z}, %{x}, %{y})",
                                                        hoverlabel = Dict("bgcolor"=> blue)))
            
    fig[:add_trace](go.Scatter3d(x=spx, y=spy, z=spz, text=sptext, name="", 
                                                                mode="markers", 
                                                                marker=Dict("size"=>10, "color"=>grey,"symbol"=>"circle-open"),
                                                                hovertemplate="%{text}: (%{z}, %{x}, %{y})",
                                                                hoverlabel = Dict("bgcolor"=> red)))                                                 


    fig[:update_layout](title="N = $N, Tree Length = $len", showlegend=false, template="none",scene=Dict(
        "xaxis" => Dict("zerolinecolor" => "black", "zerolinewidth" => 1.5),
        "yaxis" => Dict("zerolinecolor" => "black", "zerolinewidth" => 1.5),
        "zaxis" => Dict("zerolinecolor" => "black", "zerolinewidth" => 1.5)
    ))
    fig[:update_scenes](camera_projection_type="perspective")

    config = Dict("staticPlot" => false,
              "toImageButtonOptions" => Dict("format" => "png",  "scale" => 4))

    fig[:show](config=config)
end

