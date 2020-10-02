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
  name::String
  data::T
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
get_name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
get_data(node::AbstractNode) = node.data

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", get_name(node), ", data: ", get_data(node))
end

"""Surchage de l'opérateur =="""
==(node1::AbstractNode, node2::AbstractNode) = (get_name(node1) == get_name(node2) && get_data(node1) == get_data(node2))
