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
  node1_::Node{T}
  node2_::Node{T}
  weight_::Number
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `node1`, `node2` et `weight`.

""" Constructeur simplifié """
function Edge{T}(node1_::T, node2_::T; weight_::Number=0) where T
    return Edge(node1_, node2_, weight_)
end

"""Accède le noeud 1."""
get_node1(edge::AbstractEdge{T}) where T = edge.node1_

"""Accède le noeud 2."""
get_node2(edge::AbstractEdge{T}) where T = edge.node2_

"""Accède le poids de l'arête."""
get_weight(edge::AbstractEdge{T}) where T = edge.weight_

"""Affecte le noeud 1."""
function set_node1!(edge::AbstractEdge{T}, node::Node{T}) where T 
  edge.node1_ = node
  return edge
end

"""Affecte le noeud 2."""
function set_node1!(edge::AbstractEdge{T}, node::Node{T}) where T 
  edge.node2_ = node
  return edge
end

"""Affiche un noeud."""
function show(edge::AbstractEdge{T}) where T
  println("Edge of weigth ", get_weight(edge), " between the nodes \"", get_name(get_node1(edge)), "\" and \"", get_name(get_node2(edge)), "\".")
end

"""Surcharge de `isless` pour comparer les weights de deux edges"""
isless(edge1::AbstractEdge{T}, edge2::AbstractEdge{T}) where T = isless(get_weight(edge1), get_weight(edge2))

"""Surcharge de `sort` pour les edges : le sort est en ordre croissant et il est effectuée à partir des valeurs de weights"""
sort(array_edges::Array{AbstractEdge{T}}) where T = sort(array_edges)

""" Retire et renvoie l'arête de poids minimal dans un vecteur d'arêtes
  -Input : vecteur d'arêtes en type concret, Edge{T}
  -Output : arête minimal et le vecteur est soutiré de cet arête (modifié à l'interne)  
"""
function popfirst!(edges::Vector{Edge{T}}) where T  
  min_edge = minimum(edges)
  idx = findfirst(x -> x == min_edge, edges)
  deleteat!(edges, idx)
  min_edge
end

