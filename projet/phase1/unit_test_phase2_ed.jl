include("nodeTree.jl")
using Test

# NodeTree : get_root(), get_parent() et same_tree()
root = NodeTree{Int}(1) 
child_root = NodeTree{Int}(2, parent_=root)
child_of_child1 = NodeTree{Int}(3, parent_=child_root)
child_of_child2 = NodeTree{Int}(4, parent_=child_root)


@test get_parent(child_root) == root
@test get_parent(child_of_child1) == child_root

@test get_root(child_root) == root
@test get_root(child_of_child1) == root

@test same_tree(child_of_child1, child_of_child2)

# NodeTree : set_parent
root = NodeTree{Int}(1) 
child_root = NodeTree{Int}(2, parent_=nothing)
set_parent(child_root, root)

@test get_parent(child_root)==root
