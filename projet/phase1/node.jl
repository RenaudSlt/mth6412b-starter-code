import Base.show
import Base.==

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.
Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)
"""
mutable struct Node{T} <: AbstractNode{T}
  data_::T
  name_::String
end

""" Constructeur  
  -Argument obligatoire : data_
  -Argument facultatif : name_ 
    name_ = "", par défaut
"""
function Node{T}(data_::T; name_::String="") where T
    return Node(data_, name_)
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Accède au nom du noeud."""
get_name(node::AbstractNode{T}) where T = node.name_

"""Accède les données contenues dans le noeud."""
get_data(node::AbstractNode{T} where T) = node.data_

"""Affiche un noeud."""
function show(node::AbstractNode{T}) where T
  println("Node ", get_name(node), ", data: ", get_data(node))
end

"""Surchage de l'opérateur == pour deux noeuds"""
==(node1::AbstractNode{T}, node2::AbstractNode{T}) where T = (get_name(node1) == get_name(node2) && get_data(node1) == get_data(node2))
