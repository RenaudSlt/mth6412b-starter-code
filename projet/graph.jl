using LinearAlgebra
using Random
include("node.jl")
include("edge.jl")
import Base.show
import Base.deepcopy

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

""" Fonction d'utilité : supporte la fonction prime_algorithm et l'algorithme HK
    -Retourne les arêtes qui sont associés à un noeud donné
    
    Input : noeud appartenant au graph 
    Output : liste d'arêtes associés au noeud en argument
"""
function get_edges_from_node(graph::Graph{T}, node::AbstractNode{T}) where T
  
  if !(node in get_nodes(graph))
    throw(error("The node doesn't belong to the graph"))
  end

  sub_edges = Edge{T}[]
  for edge in get_edges(graph)

    if (get_node1(edge) == node || get_node2(edge) == node)
      push!(sub_edges, edge)
    end
  end
  return sub_edges
  
end

""" Construction d'une matrice d'adjacence à partir d'un graph
    Input : 
      -un graph non-orienté
    Output :
      -une matrice d'adjacence
"""
function build_matrix!(G::Graph{T}) where T

    matrix = ones(typeof(get_weight(get_edges(G)[1])), nb_nodes(G), nb_nodes(G))*Inf
    
    #for (index, node) in enumerate(get_nodes(G))
    #    set_index!(node, index)
    #end
    
    for edge in get_edges(G)
        index_1 = get_index(get_node1(edge))
        index_2 = get_index(get_node2(edge))

        if get_weight(edge)!=0
          matrix[index_1, index_2] = get_weight(edge)
          matrix[index_2, index_1] = matrix[index_1, index_2]
        end
    end
    
    return matrix
end


""" Supprime un noeud et les arêtes adjacentes à un graph non-orienté"""
function remove_node_from_graph!(graph::AbstractGraph{T}, node::Node{T}) where T
  # Soutraction du noeud
  filter!(x -> x ≠ node, get_nodes(graph))
  # Soustraction des arêtes
  filter!(x -> !(get_node1(x)==node || get_node2(x)==node), get_edges(graph) )
end


""" Fonction utilité pour l'algorithme HK (voir fichier hk_algorithm) :
    -Modification des coûts des arêtes à partir d'un vecteur qui attribue 
     des valeurs à chaque noeud du graph
     
    Input:
      -un graph non-orienté
      -un vecteur de taille du nombre de noeuds du graph

"""
function update_weights!(graph::AbstractGraph{T}, π::Vector{Float64}) where T
    for edge in get_edges(graph)
        set_weight!( edge, get_weight(edge) +  π[get_index(get_node1(edge))]  + π[get_index(get_node2(edge))] )
    end
end

""" Fonction utilité pour l'algorithme HK (voir fichier hk_algorithm) :
    Input:
      -Un graph non-orienté contenant des arêtes et des noeuds
    Output:
      -Un vecteur contenant le degré de chaque noeud 
"""
function get_degrees(graph::AbstractGraph{T}) where T

    degrees = zeros(nb_nodes(graph))

    for edge in get_edges(graph)
        degrees[get_index(get_node1(edge))] += 1 
        degrees[get_index(get_node2(edge))] += 1
    end
    return degrees
end

""" Constructeur par copie profonde """
function deepcopy(graph::AbstractGraph{T}) where T
  return Graph(get_name(graph), deepcopy(get_nodes(graph)) , deepcopy(get_edges(graph)))
end  


""" Fonction utilité : reconstruire """
function post_process_one_tree!(one_tree::Graph{T}, initial_graph::Graph{T}) where T
  v = get_degrees(one_tree) .- 2
  idx_ones = findall(x -> x == 1, v)
  idx_minus_ones = findall(x -> x == -1, v)
  added_edges = Edge{T}[]

  while !isempty(idx_ones)

    p = pop!(idx_ones)
    q = pop!(idx_minus_ones)
    node3 = get_nodes(one_tree)[p]  # un noeud de degré 3
    node1 = get_nodes(one_tree)[q]  # un noeud de degré 1
    edges = get_edges_from_node(one_tree, node3) # arêtes incidentes au noeud de degré 3
    edge_min = popfirst!(edges) # on prend l'arête de poids minimal

    # Cas dans lequel node1 et node3 sont adjacents
    if (get_node1(edge_min) == node1 || get_node2(edge_min) == node1)
      edge_min = popfirst!(edges)
    end

    # Cas dans lequel la modification entraine des tournées indépendantes
    one_tree_is_connected = is_connected(one_tree, initial_graph, node3, node1, edge_min)
    # S'il reste des arêtes incidentes à node3, on prend la suivante
    if !one_tree_is_connected && !isempty(edges)
      edge_min = popfirst!(edges)
    # S'il ne reste pas d'arêtes incidentes à node3, on recommence en mélangeant les éléments de idx_ones
    elseif !one_tree_is_connected && isempty(edges)
      push!(idx_ones, p)
      push!(idx_minus_ones, q)
      shuffle!(idx_ones)
      continue
    end


    # Trouver le noeud à l'autre bout de edge_min (i.e. pas node3)
    v = (node3 == get_node1(edge_min)) ? get_node2(edge_min) : get_node1(edge_min)
    # Trouver l'arête entre v et node1 dans le graphe initial et l'ajouter à one_tree
    for edge in get_edges(initial_graph)
      if (get_node1(edge) == v && get_node2(edge) == node1) || (get_node2(edge) == v && get_node1(edge) == node1)
        add_edge!(one_tree, Edge{Nothing}(v, node1, get_weight(edge)))
      end
    end

    # Retirer l'arête entre node3 et v de one_tree
    for edge in get_edges(one_tree)
      if (get_node1(edge) == v && get_node2(edge) == node3) || (get_node2(edge) == v && get_node1(edge) == node3)
        filter!(x-> x!=edge, get_edges(one_tree) )
      end
    end
  end

  return one_tree
end

""" Fonction d'utilité de post_process_one_tree qui s'assure qu'on ne créé pas un graphe non connexe """
function is_connected(one_tree, initial_graph, node3, node1, edge_min)
  
  one_tree_copy = deepcopy(one_tree)
  # Partie où l'on fait la transformation prescrite par node3, node1 et edge_min (comme dans post_process_one_tree!())
  # Trouver le noeud à l'autre bout de edge_min (i.e. pas node3)
  v = (node3 == get_node1(edge_min)) ? get_node2(edge_min) : get_node1(edge_min)
  # Trouver l'arête entre v et node1 dans le graphe initial et l'ajouter à one_tree_copy
  for edge in get_edges(initial_graph)
    if (get_node1(edge) == v && get_node2(edge) == node1) || (get_node2(edge) == v && get_node1(edge) == node1)
      add_edge!(one_tree_copy, Edge{Nothing}(v, node1, get_weight(edge)))
    end
  end

  # Retirer l'arête entre node3 et v de one_tree_copy
  for edge in get_edges(one_tree_copy)
    if (get_node1(edge) == v && get_node2(edge) == node3) || (get_node2(edge) == v && get_node1(edge) == node3)
      filter!(x-> x!=edge, get_edges(one_tree_copy) )
    end
  end
  
  # Partie où l'on s'assure que one_tree_copy est connexe
  ensembles = []
  for edge in get_edges(one_tree_copy)
    node1 = get_index(get_node1(edge))
    node2 = get_index(get_node2(edge))
    node1_found = false
    node2_found = false
    index_ens_node1 = 0
    index_ens_node2 = 0
    # On trouve les ensembles qui contiennent node1 et node 2
    for i in 1:length(ensembles)
      if node1 in ensembles[i]
        node1_found = true
        index_ens_node1 = i
      end
      if node2 in ensembles[i]
        node2_found = true
        index_ens_node2 = i
      end
    end
    
    # Si node1 et node2 sont déjà dans des ensembles
    if node1_found && node2_found
      # Si node1 et node2 ne sont dans les mêmes ensembles, on fusionne ces ensembles
      if index_ens_node1 != index_ens_node2
        ensembles[index_ens_node1] = vcat(ensembles[index_ens_node1], ensembles[index_ens_node2])
        deleteat!(ensembles, index_ens_node2)
      end
    # Si seulement node1 est dans un ensemble, on ajoute node2 à ce même ensemble
    elseif node1_found
      push!(ensembles[index_ens_node1], node2)
    # Et réciproquement
    elseif node2_found
      push!(ensembles[index_ens_node2], node1)
    # Si aucun noeud n'est dans un ensemble, on en créé un nouveau
    else
      push!(ensembles, [node1,node2])
    end
  end
  
  if length(ensembles) == 1
    return true
  end
  return false 
end