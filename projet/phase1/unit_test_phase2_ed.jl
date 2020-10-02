include("nodeTree.jl")
include("node.jl")
using Test

# NodeTree : get_root(), get_parent() et same_tree()
root = NodeTree{Int}(1) 
child_root = NodeTree{Int}(2, parent_=root)
child_of_child1 = NodeTree{Int}(3, parent_=child_root)
child_of_child2 = NodeTree{Int}(4, parent_=child_root)


@test get_parent(child_root) == root
@test get_parent(child_of_child1) == child_root

@test get_root(root) == root
@test get_root(child_root) == root
@test get_root(child_of_child1) == root

@test same_tree(child_of_child1, child_of_child2)

# NodeTree : set_parent!()
root = NodeTree{Int}(1) 
child_root = NodeTree{Int}(2, parent_=nothing)
set_parent!(child_root, root)

@test get_parent(child_root)==root


# NodeTree : operateur ==, voir si changement se font par référence
a = NodeTree{Int}(1, name_="Spongebob")
b = a # b référence a
@test a==b
c = Node{Int}("Spongebob", 1)
@test a == c


parent = NodeTree{Int}(2, name_="Jean")
set_parent!(b, parent)
@test get_parent(a)==parent 
