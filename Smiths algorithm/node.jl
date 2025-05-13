"""
node struct is used in the priority queue. 
It stores the parent node, level and edge which has been split.

"""
struct node{T1<:Int}
    parent::Union{Nothing,node{T1}}
    level::T1
    edgeSplit::T1

    node{T1}() where T1 = new{T1}(nothing,0,0)

    node{T1}(e::Integer, n::node{T1}) where T1 = new{T1}(n, n.level+1, e)
end