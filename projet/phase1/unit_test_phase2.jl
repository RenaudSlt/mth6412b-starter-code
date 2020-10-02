using Test

include("node.jl")
include("edge.jl")
#include("nodeTree.jl")
#include("kruskal_algorithm.jl")

node_1 = Node("1", nothing)
node_2 = Node("2", nothing)
node_3 = Node("3", nothing)
edge_1 = Edge(node_1, node_2, 1)
edge_2 = Edge(node_2, node_3, 2)

# Methode : same_tree
#@test ...

# Methode : popfirst!
edges_ = [edge_1]
push!(edges_, edge_2)

@test popfirst!(edges_) == edge_1
popfirst!(edges_)


# TreeNode : get_root() 
root = TreeNode(1) # where T=Int and (parent=nothing) by default
child_root = TreeNode(2, parent=root)
child_of_child = TreeNode(3, parent=child_root)

@test get_root(child_of_child)==root
