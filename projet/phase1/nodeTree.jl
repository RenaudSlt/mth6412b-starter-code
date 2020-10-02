include("node.jl")

mutable struct TreeNode{T} <: AbstractNode{T}
    data::T
    name::String
    parent::Union{TreeNode{T}, Nothing} 
end


""" Constructeur simplifié : on obligatoirement doit spécifier le type de data en argument """
function TreeNode(data::T; name::String="", parent::Union{TreeNode{T}, Nothing}=nothing) where T
    return TreeNode(data, name, parent)
end

"""Accède au noeud parent d'un noeud"""
get_parent(node::TreeNode) = node.parent

"""Ajuste le noeud parent d'un noeud (node1) en tant qu'un autre noeud (node2)""" 
function  set_parent(child::TreeNode{T}, parent::TreeNode{T}) where T
   child.parent = parent
   return child
end

"""Retourne le noeud racine d'une composante composante_connexe
Output : 
    -Si !(node_temp === nothing) => le noeud a une racine
    -Si (node_temp === nothing) => le noeud est une racine
"""
function get_root(node::TreeNode{T}) where T

    node_temp = get_parent(node)
    while !(node_temp === nothing)
        node_temp = get_parent(node_temp)
    end

    return node_temp
end


"""Vérifie si deux noeuds appartiennent aux mêmes arbres en comparant leur noeud racine"""
function same_tree(node1::TreeNode{T}, node2::TreeNode{T}) where T
    root_tree1 = get_root(node1)
    root_tree2 = get_root(node2)
    return root_tree1 == root_tree2 
end