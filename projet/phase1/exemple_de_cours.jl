include("node.jl")
include("edge.jl")
include("graph.jl")
include("kruskal_algorithm.jl")

G = Graph{Nothing}()
set_name!(G, "exemple de cours")
nodes_names = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]

# Ajouter les noeuds
for i in 1:length(nodes_names)
  add_node!(G, Node(nodes_names[i], nothing))
end

# Ajouter les arêtes
add_edge!( G, Edge(get_nodes(G)[1], get_nodes(G)[2], 4) )
add_edge!( G, Edge(get_nodes(G)[1], get_nodes(G)[8], 8) )
add_edge!( G, Edge(get_nodes(G)[2], get_nodes(G)[8], 11) )
add_edge!( G, Edge(get_nodes(G)[2], get_nodes(G)[3], 8) )
add_edge!( G, Edge(get_nodes(G)[9], get_nodes(G)[3], 2) )
add_edge!( G, Edge(get_nodes(G)[9], get_nodes(G)[8], 7) )
add_edge!( G, Edge(get_nodes(G)[9], get_nodes(G)[7], 6) )
add_edge!( G, Edge(get_nodes(G)[8], get_nodes(G)[7], 1) )
add_edge!( G, Edge(get_nodes(G)[6], get_nodes(G)[7], 2) )
add_edge!( G, Edge(get_nodes(G)[6], get_nodes(G)[3], 4) )
add_edge!( G, Edge(get_nodes(G)[3], get_nodes(G)[4], 7) )
add_edge!( G, Edge(get_nodes(G)[5], get_nodes(G)[4], 9) )
add_edge!( G, Edge(get_nodes(G)[6], get_nodes(G)[4], 14) )
add_edge!( G, Edge(get_nodes(G)[6], get_nodes(G)[5], 10) )


kruskal_algorithm(G)