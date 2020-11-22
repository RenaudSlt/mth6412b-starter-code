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
  index_::Int
end

""" Constructeur  
      -Argument obligatoire : data_
      -Argument facultatif : name_ 
          name_ = "", par défaut
         index_ = 0, par défaut
"""
function Node{T}(data_::T; name_::String="", index_::Int=0) where T
    return Node(data_, name_, index_)
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Accède au nom du noeud."""
get_name(node::AbstractNode{T}) where T = node.name_

"""Accède les données contenues dans le noeud."""
get_data(node::AbstractNode{T}) where T = node.data_

"""Accède l'index du noeud."""
get_index(node::AbstractNode{T}) where T = node.index_

"""Accède au nom du noeud."""
function set_name!(node::AbstractNode{T}, name::String) where T 
   node.name_ = name
end

"""Mutateur du nom du noeud."""
function set_data!(node::AbstractNode{T}, data::T) where T 
   node.data_ = data
end

"""Mutateur du nom du noeud."""
function set_index!(node::AbstractNode{T}, index::Int) where T 
   node.index_ = index
end

"""Affiche un noeud."""
function show(node::AbstractNode{T}) where T
  println("Node ", get_name(node), ", data: ", get_data(node))
end

"""Surchage de l'opérateur == pour deux noeuds"""
==(node1::AbstractNode{T}, node2::AbstractNode{T}) where T = (get_name(node1) == get_name(node2) && get_data(node1) == get_data(node2))
