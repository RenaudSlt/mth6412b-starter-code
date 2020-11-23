using Test

include("node.jl")
include("nodetree.jl")
include("edge.jl")

node_1 = Node("1", nothing)
node_2 = Node("2", nothing)
node_3 = Node("3", nothing)
edge_1 = Edge(node_1, node_2, 1)
edge_2 = Edge(node_2, node_3, 2)


# Methode : popfirst!
edges_ = [edge_1]
push!(edges_, edge_2)

@test popfirst!(edges_) == edge_1
popfirst!(edges_)

# NodeTree : get_root(), get_parent() et same_tree()
root = NodeTree{Int}(1) 
child_root = NodeTree{Int}(2, parent_=root)
child_of_child1 = NodeTree{Int}(3, parent_=child_root)
child_of_child2 = NodeTree{Int}(4, parent_=child_root)

# get_root() pour l'enfant direct et l'enfant de l'enfant
@test get_parent(child_root) == root
@test get_parent(child_of_child1) == child_root
@test get_root(root) == root  #devrait sortir nothing
@test get_root(child_root) == root
@test get_root(child_of_child1) == root

# same_tree()
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

# Test : les instances d'un type sont passés par référence lors d'une affectation 
c = Node{Int}("Spongebob", 1)
@test a == c
parent = NodeTree{Int}(2, name_="Jean")
set_parent!(b, parent)
@test get_parent(a)==parent 


