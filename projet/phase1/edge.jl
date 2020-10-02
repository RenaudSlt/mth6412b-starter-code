include("node.jl")

import Base.show
import Base.popfirst!
import Base.sort
import Base.isless
import Base.==

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Lars", 2)
    edge = Edge(node1, node2, 2.36)
    edge = Edge(node2, node3, 0)

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Edge{T} <: AbstractEdge{T}
  node1::Node{T}
  node2::Node{T}
  weight::Number
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `node1`, `node2` et `weight`.

"""Renvoie le noeud 1."""
get_node1(edge::AbstractEdge) = edge.node1

"""Renvoie le noeud 2."""
get_node2(edge::AbstractEdge) = edge.node2

"""Set le noeud 1."""
function set_node1!(edge::AbstractEdge, node::Node) 
  edge.node1 = node
  return edge
end

"""Set le noeud 2."""
function set_node1!(edge::AbstractEdge, node::Node) 
  edge.node2 = node
  return edge
end


"""Renvoie le poids de l'arête."""
get_weight(edge::AbstractEdge) = edge.weight

"""Affiche un noeud."""
function show(edge::AbstractEdge)
  println("Edge of weigth ", get_weight(edge), " between the nodes \"", get_name(get_node1(edge)), "\" and \"", get_name(get_node2(edge)), "\".")
end

"""Surcharge de `isless` pour comparer les weights de deux edges"""
#Base.:(<=)(edge1::AbstractEdge, edge2::AbstractEdge) = (weight(edge1) <= weight(edge2))
isless(edge1::AbstractEdge, edge2::AbstractEdge) = isless(get_weight(edge1), get_weight(edge2))


"""Surcharge de `sort` pour les edges : le sort est en ordre croissant et il est effectuée à partir des valeurs de weights"""
sort(array_edges::Array{AbstractEdge}) = sort(array_edges)
#popfirst!(array_edges::Array{AbstractEdge}) = popfirst!(array_edges)


""" Retire et renvoie l'arête de poids minimal dans un vecteur d'arêtes """
function popfirst!(edges::Vector{Edge{T}}) where T  
  min_edge = minimum(edges)
  show(min_edge)
  idx = findfirst(x -> x == min_edge, edges)
  deleteat!(edges, idx)
  min_edge
end

