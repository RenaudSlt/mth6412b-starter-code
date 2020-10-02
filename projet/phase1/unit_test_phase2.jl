include("node.jl")
include("nodeTree.jl")
include("kruskal_algorithm.jl")

# Methode : same_tree
@test ....


# TreeNode : get_root() 
root = TreeNode(1) # where T=Int and (parent=nothing) by default
child_root = TreeNode(2, parent=root)
child_of_child = TreeNode(3, parent=child_root)

@test get_root(child_of_child)==root