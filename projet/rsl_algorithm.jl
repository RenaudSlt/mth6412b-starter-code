include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("markednode.jl")
include("edge.jl")
include("prim_algorithm.jl")
include("kruskal_algorithm.jl")

""" Parcourt l'arbre tree en pre-ordre et sauvegarde les noeuds dans route """
function parcours_preordre(tree::Union{MarkedNode,Nothing}, route)
  tree === nothing && return route
  push!(route, tree)
  for child in get_children(tree)
    parcours_preordre(child, route)
  end
end


""" Algorithme de RSL
    Input : . un graphe de type Graph
            . un algorithme d'abre de recouvrement de type String
            . une source de type Node
    Output : . tournée sous forme de vecteur de nœuds
             . tournée sous forme de vecteur d'arêtes
             . cout de la tournée
"""
function rsl_algorithm(graph::Graph{T}, algo::String, source::Node{T}=get_nodes(graph)[1]) where T

  if algo == "kruskal"
    arcs_minimaux, poids_minimal, arbre_minimal = kruskal_by_prim(graph, source)
  elseif algo == "prim"
    arcs_minimaux, poids_minimal, arbre_minimal = prim_algorithm(graph, source)
  end

  # Création et remplissage de la liste dans laquelle sont stockés les sommets dans l'ordre
  route_nodes = []
  parcours_preordre(get_root(arbre_minimal[1]), route_nodes)

  # On retrouve les arêtes correspondant aux sommets successifs de la route
  edges = get_edges(graph)
  route_edges = []
  route_weight = 0
  for i in 1:(length(route_nodes)-1)
    for edge in edges
      if (get_node1(edge) == route_nodes[i] && get_node2(edge) == route_nodes[i+1]) || (get_node1(edge) == route_nodes[i+1] && get_node2(edge) == route_nodes[i])
        push!(route_edges, edge)
        route_weight += get_weight(edge)
        continue
      end
    end
  end

  # Ajout de la dernière arête qui retourne au départ
  start = route_nodes[1]
  last = route_nodes[length(route_nodes)]
  for edge in edges
    if (get_node1(edge) == start && get_node2(edge) == last) || (get_node1(edge) == last && get_node2(edge) == start)
      push!(route_edges, edge)
      route_weight += get_weight(edge)
    end
  end

  return route_nodes, route_edges, route_weight
end