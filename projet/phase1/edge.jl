import Base.show

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
Node1(edge::AbstractEdge) = edge.node1

"""Renvoie le noeud 2."""
Node2(edge::AbstractEdge) = edge.node2

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche un noeud."""
function show(edge::AbstractEdge)
  println("Edge of weigth ", weight(edge), " between the nodes \"", name(Node1(edge)), "\" and \"", name(Node2(edge)), "\".")
end

"""Surcharge de l'opérateur <= pour les arcs d'un edge"""
Base.:(<=)(edge1::AbstractEdge, edge2::AbstractEdge) = (weight(edge1) <= weight(edge2))