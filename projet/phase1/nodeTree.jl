include("node.jl")
import Base.==

mutable struct NodeTree{T} <: AbstractNode{T}
    data_::T
    name_::String
    parent_::Union{NodeTree{T}, Nothing} 
end


""" Constructeur simplifié : on obligatoirement doit spécifier le type de data en argument """
function NodeTree{T}(data_::T; name_::String="", parent_::Union{NodeTree{T}, Nothing}=nothing) where T
    return NodeTree(data_, name_, parent_)
end

"""Accède au noeud parent d'un noeud"""
get_parent(node::NodeTree{T}) where T = node.parent_

"""Accède au data d'un noeud"""
get_data(node::NodeTree{T}) where T = node.data_

"""Accède au nom d'un nom"""
get_name(node::NodeTree{T}) where T = node.name_


"""Ajuste le noeud parent d'un noeud (node1) en tant qu'un autre noeud (node2)
Input : 
    -child : 
    -
""" 
function set_parent!(child::NodeTree{T}, parent::NodeTree{T}) where T 
   child.parent_ = parent
   return child
end

"""Retourne le noeud racine d'une composante composante_connexe
Output : 
    -Si !(node_temp === nothing) => le noeud a une racine
    -Si (node_temp === nothing) => le noeud est une racine
"""
function get_root(node::NodeTree{T}) where T 

    # Construction par copie pour éviter de modifier la structure interne
    #temp_node = NodeTree{T}(get_data(node), parent_ = get_parent(node))

    #if get_parent(temp_node) === nothing  # Il est une racine
    #    return temp_node 
    #else
    #    temp_parent = get_parent(temp_node)
    #    temp_node = NodeTree{T}( get_data(temp_parent), parent_=get_parent(temp_parent) )
    #    get_root(temp_node)
    #end

    if get_parent(node) === nothing  # Il est une racine
        return node 
    else
        get_root(get_parent(node))
    end

end


"""Vérifie si deux noeuds appartiennent aux mêmes arbres en comparant leur noeud racine"""
function same_tree(node1::NodeTree{T}, node2::NodeTree{T}) where T 
    root_tree1 = get_root(node1)
    root_tree2 = get_root(node2)
    return root_tree1 == root_tree2 
end

"""Surchage"""
==(tree_node::NodeTree{T}, simple_node::Node{T}) where T = ( get_name(tree_node)==get_name(simple_node) && get_data(tree_node)==get_data(simple_node) )
==(simple_node::Node{T}, tree_node::NodeTree{T}) where T = (==(tree_node, simple_node))