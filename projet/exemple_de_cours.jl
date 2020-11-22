include("node.jl")
include("edge.jl")
include("graph.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
using Test

# Créer le graphe
G = Graph{Nothing}()
set_name!(G, "exemple de cours")

# Ajouter les noeuds
nodes_names = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
for i in 1:length(nodes_names)
  add_node!(G, Node{Nothing}(nothing, nodes_names[i]))
end

# Ajouter les arêtes
add_edge!( G, Edge{Nothing}(get_nodes(G)[1], get_nodes(G)[2], 4) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[1], get_nodes(G)[8], 8) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[2], get_nodes(G)[8], 11) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[2], get_nodes(G)[3], 8) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[9], get_nodes(G)[3], 2) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[9], get_nodes(G)[8], 7) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[9], get_nodes(G)[7], 6) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[8], get_nodes(G)[7], 1) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[7], 2) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[3], 4) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[3], get_nodes(G)[4], 7) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[5], get_nodes(G)[4], 9) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[4], 14) )
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[5], 10) )


"""
# Rouler l'algorithme de Kruskal
arcs_minimaux_K, poids_minimal_K, arbre_minimal_K = kruskal_algorithm(G)

for node in arbre_minimal_K
  show(node)
  println(get_parent(node) == nothing ? "nothing" : get_name(get_parent(node)))
end
"""

# Rouler l'aglorithme de Prim
arcs_minimaux_P, poids_minimal_P, arbre_minimal_P = prim_algorithm(G, get_nodes(G)[1])

for node in arbre_minimal_P
  show(node)
  println("parent de ", get_name(node), " : ", get_parent(node) == nothing ? "nothing" : get_name(get_parent(node)))
  print("enfants de ", get_name(node), " : ")
  for child in get_children(node)
    print(get_name(child), ", ")
  end
  println("\n")
end
