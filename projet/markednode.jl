include("node.jl")

import Base.show
import Base.popfirst!
import Base.isless

"""Type représentant un noeud marqué avec une structure d'arbre
    - L'attribut min_weight_ a vocation à être le poids de l'arête de poids minimal connectant le noeud au sous arbre dans l'algorithme de Prim
    - Si parent_ == nothing => le NodeTree est une racine
"""

mutable struct MarkedNode{T} <: AbstractNode{T}
    name_::String
    data_::T
    visited_::Bool
    min_weight_::Float64
    parent_::Union{MarkedNode{T},Nothing}
end

""" Constructeur :
    - Argument obligatoire : data_
    - Argument facultatif : name_ et min_weight
        name_ = "", par défaut
        min_weight_ = Inf, par défaut
"""
function MarkedNode(data::T; name::String="", min_weight::Float64=Inf) where T
    MarkedNode(name, data, false, max(0.0, min_weight), nothing)
end

""" Accesseur à l'attribut visited_ """
get_visited(node::MarkedNode) = node.visited_

""" Accesseur à l'attribut min_weight_ """
get_min_weight(node::MarkedNode) = node.min_weight_

""" Accesseur à l'attribut parent_ """
get_parent(node::MarkedNode) = node.parent_

""" Mutateur de l'attribut visited_ (irréversible) """
function set_visited!(node::MarkedNode)
    node.visited_ = true
    node
end

""" Mutateur de l'attribut min_weight_ """
function set_min_weight!(node::MarkedNode, weight::Float64)
    node.min_weight_ = max(0.0, weight)
    node
end

""" Mutateur de l'attribut parent_ """
function set_parent!(node::MarkedNode{T}, parent::MarkedNode{T}) where T
    node.parent_ = parent
    node
end

""" Affichage du noeud """
show(node::MarkedNode) = println("node $(get_name(node)) of minimum weight to tree $(get_min_weight(node))")

""" Surcharge de `isless` pour comparer les attributs min_weight_ de deux MarkedNodes """
isless(node1::MarkedNode{T}, node2::MarkedNode{T}) where T = isless(get_min_weight(node1), get_min_weight(node2))

""" Retire et renvoie le noeud d'attribut min_weight_ minimal dans un vecteur de MarkedNodes
  - Input : vecteur de MarkedNodes
  - Output : noeud d'attribut min_weight_ minimal 
"""
function popfirst!(nodes::Vector{MarkedNode{T}}) where T  
  min_node = minimum(nodes)
  idx = findfirst(x -> x == min_node, nodes)
  deleteat!(nodes, idx)
  min_node
end