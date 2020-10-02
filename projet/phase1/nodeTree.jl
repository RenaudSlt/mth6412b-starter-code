include("node.jl")

mutable struct TreeNode{T} <: AbstractNode{T}
    name::String
    parent::Union{TreeNode{T}, Nothing} 
    data::T
end


""" Constructeur : construit à partir d'un Node{T} """
#Solution 1
#function TreeNode{T}(node::Node{T}) where { T<:typeof(data(node)) }
#function TreeNode(node::Node{T})
#    return TreeNode(name(node), nothing , data(node)) 
#end

#Solution 2 : initialiser vide et setters
function TreeNode(data::T; name::String="", parent::Union{TreeNode{T}, Nothing}=nothing) where T
    return TreeNode(name, parent, data)
end


""" Utility function for function belong same tree"""
function get_root(node::TreeNode{T}) where T
    # retourne la racine d'un arbre
    # get_parent() jusqu'à ce qu'on atteigne nothing (if node.parent == )
    node
end


""" 
Returns a boolean
"""
function same_tree(node1::TreeNode{T}, node2::TreeNode{T}) where T
    composante_connexe1 = get_root(node1)
    composante_connexe2 = get_root(node2)
end


"""Renvoie la liste des noeuds du graphe."""
get_parent(node::TreeNode) = node.parent


"""Setter parent"""
function  set_parent(node1::TreeNode{T}, node2::TreeNode{T}) where T
   node1.parent = node2 
end

"""Setter parent"""
function union_tree!(node1::TreeNode{T}, node2::TreeNode{T}) where T
    root1 = get_root(node1)
    root2 = get_root(node2)
    #index_root1 = findfirst( x-> x==root1, array_tree_nodes)
    #index_root2 = findfirst( x-> x==root2, array_tree_nodes)

    #set_parent!(array_TN[index_root2], array_TN[index_root1])

    #return array_TN
end



