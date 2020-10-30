include("node.jl")
include("edge.jl")
import Base.show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds et d'arêtes.
Exemple :
    node_a = Node("Joe", 3.14)
    node_b = Node("Steve", exp(1))
    node_c = Node("Jill", 4.12)
    edge1 = Edge(node_a, node_b, 3.0)
    edge2 = Edge(node_b, node_c, -1)
    G = Graph("Ick", [node_a, node_b, node_c], [edge1, edge2])
Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name_::String
  nodes_::Vector{Node{T}}
  edges_::Vector{Edge{T}}
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name`, `nodes` et `edges`.

"""Constructeur supplémentaire : 
    -Implémentation équivalente : Graph{T}() where T = Graph("", Array{Node{T}}(undef,0), Array{Edge{T}}(undef,0))
"""
Graph{T}() where T = Graph("", Node{T}[], Edge{T}[])

"""Affecte le nom du graph : fonction à utiliser avec le constructeur supplémentaire """
function set_name!(graph::Graph{T}, name::String) where T
  graph.name_ = name
  graph
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes_, node)
  graph
end

""" Ajoute une arête au graphe en s'assurant qu'elle relie bien deux noeux appartenant au graphe. """
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  if !(get_node1(edge) in get_nodes(graph)) || !(get_node2(edge) in get_nodes(graph))
    @error("Impossible to add edge.\nAt least one of the following nodes is not in the graph :", get_node1(edge), get_node2(edge))
  else
    push!(graph.edges_, edge)
    graph
  end
end

"""Accède au nom du graphe."""
get_name(graph::AbstractGraph{T}) where T = graph.name_

"""Renvoie la liste des noeuds du graphe."""
get_nodes(graph::AbstractGraph{T}) where T = graph.nodes_

"""Renvoie la liste des arêtes du graphe."""
get_edges(graph::AbstractGraph{T}) where T = graph.edges_

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph{T}) where T = length(graph.nodes_)

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph{T}) where T = length(graph.edges_)

"""Affiche un graphe
  -On affiche le nom, le nombre de noeuds et le nombre d'arcs
  -On affiche les composantes du graphe : les attributs nodes et edges
"""
function show(graph::Graph{T}) where T
  println("Graph ", get_name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("\nNodes :")
  for node in get_nodes(graph)
    show(node)
  end
  println("\nEdges :")
  for edge in get_edges(graph)
    show(edge)
  end
end


""" Fonction d'utilité : supporte la fonction prime_algorithm
    -Retourne les arêtes qui sont associés à un noeud donné
    
    Input : noeud appartenant au graph 
    Output :
"""
#function get_edges_from_node(graph::Graph{T}, node::Node{T}) where T
function get_edges_from_node(graph::Graph{T}, node::AbstractNode{T}) where T
  
  if !(node is get_nodes(graph))
    @error("The node doesn't belong to the graph")
  else
    
    sub_edges = Edge{T}[]
    for edge in get_edges(graph)

      if (get_node1(edge) == node || get_node2(edge) == node)
        push!(sub_edges, edge)
      end
    end
    return sub_edges
  end

end