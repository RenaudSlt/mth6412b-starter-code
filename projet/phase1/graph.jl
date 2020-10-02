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
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T}}
end

"""Constructeur supplémentaire : permet d'initialiser un graph en paramétrant seulement le graph

Exemple : 
    graph = Graph{Int}()  #les sommets du graph contiendront des Int comme type de data
    graph = Graph{Float}()  #les sommets du graph contiendront des Float comme type de data

Implémentation équivalente :
    Graph{T}() where T = Graph("", Array{Node{T}}(undef,0), Array{Edge{T}}(undef,0))
"""
Graph{T}() where T = Graph("", Node{T}[], Edge{T}[])

""" Méthode qui set le nom du graph : fonction à utiliser avec le constructeur supplémentaire """
function set_name!(graph::Graph{T}, name_::String) where T
  graph.name = name_
  graph
end


"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

""" Ajoute une arête au graphe en s'assurant qu'elle relie bien deux noeux appartenant au graphe. """
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  if !(node1(edge) in nodes(graph)) || !(node2(edge) in nodes(graph))
    @error("Impossible to add edge.\nAt least one of the following nodes is not in the graph :", node1(edge), node2(edge))
  else
    push!(graph.edges, edge)
    graph
  end
end


# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name`, `nodes` et `edges`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("\nNodes :")
  for node in nodes(graph)
    show(node)
  end
  println("\nEdges :")
  for edge in edges(graph)
    show(edge)
  end
end
