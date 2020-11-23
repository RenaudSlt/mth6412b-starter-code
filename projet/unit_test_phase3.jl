include("read_stsp.jl")
include("node.jl")
include("edge.jl")
include("graph.jl")
include("markednode.jl")
include("nodetree.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")

using Test

### Se placer dans le répertoire 'mth6412b-starter-code ###


### Exemple du cours  ###

# Créer le graphe
G = Graph{Nothing}()
set_name!(G, "exemple de cours")

# Ajouter les noeuds
nodes_names = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
for i in 1:length(nodes_names)
  add_node!(G, Node{Nothing}(nothing, nodes_names[i]))
end

# Ajouter les arêtes
add_edge!( G, Edge{Nothing}(get_nodes(G)[1], get_nodes(G)[2], 4) )  #edge 1
add_edge!( G, Edge{Nothing}(get_nodes(G)[1], get_nodes(G)[8], 8) )  #edge 2
add_edge!( G, Edge{Nothing}(get_nodes(G)[2], get_nodes(G)[8], 11) ) #edge 3
add_edge!( G, Edge{Nothing}(get_nodes(G)[2], get_nodes(G)[3], 8) )  #edge 4
add_edge!( G, Edge{Nothing}(get_nodes(G)[9], get_nodes(G)[3], 2) )  #edge 5
add_edge!( G, Edge{Nothing}(get_nodes(G)[9], get_nodes(G)[8], 7) )  #edge 6
add_edge!( G, Edge{Nothing}(get_nodes(G)[9], get_nodes(G)[7], 6) )  #edge 7
add_edge!( G, Edge{Nothing}(get_nodes(G)[8], get_nodes(G)[7], 1) )  #edge 8
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[7], 2) )  #edge 9
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[3], 4) )  #edge 10
add_edge!( G, Edge{Nothing}(get_nodes(G)[3], get_nodes(G)[4], 7) )  #edge 11
add_edge!( G, Edge{Nothing}(get_nodes(G)[5], get_nodes(G)[4], 9) )  #edge 12
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[4], 14) ) #edge 13
add_edge!( G, Edge{Nothing}(get_nodes(G)[6], get_nodes(G)[5], 10) ) #edge 14


### graph.jl ###
# get_edges_from_node() pour le premier noeud 
sub_edges_node1 = get_edges_from_node(G, get_nodes(G)[1]) 

@testset "multiple edge comparison" begin
        @test sub_edges_node1[1] == get_edges(G)[1]
        @test sub_edges_node1[2] == get_edges(G)[2]
    end

# get_edges_from_node() pour le septième
sub_edges_node7 = get_edges_from_node(G, get_nodes(G)[7]) 
@testset "multiple edge comparison" begin
        @test sub_edges_node7[1] == get_edges(G)[7]
        @test sub_edges_node7[2] == get_edges(G)[8]
        @test sub_edges_node7[3] == get_edges(G)[9]
    end

# Test pour un noeud qui n'appartient pas à G
@test_throws ErrorException get_edges_from_node(G, Node{Nothing}(nothing, "bob"))


### kruskal_algorithm.jl et nodeTree.jl ###
node_tree1 = NodeTree{Int}(1)
node_tree2 = NodeTree{Int}(2)
node_tree3 = NodeTree{Int}(3)

# Test compression dans methode get_root!()
set_parent!(node_tree2, node_tree1)
set_parent!(node_tree3, node_tree2)
get_root!(node_tree3)

@test get_parent(node_tree2) == get_parent(node_tree3)


### prim_algorithm et markedTree.jl ###
node_marked1 = MarkedNode{Int}(1, min_weight_=1)
node_marked2 = MarkedNode{Int}(1, min_weight_=2)
node_marked3 = MarkedNode{Int}(1, min_weight_=3)
array_marked_nodes = MarkedNode{Int}[node_marked2, node_marked1, node_marked3] 

# test pop_first!() : le noeud avec le min_weight_ minimal est extrait
@test popfirst!(array_marked_nodes) == node_marked1
array_marked_nodes = MarkedNode{Int}[]

# test pour pop_first!() sur une liste vide
@test_throws ErrorException popfirst!(array_marked_nodes)


### Exemple de cours : comparaison prim_algorithm et kruskal_algorithm ###
arcs_minimaux_K, poids_minimal_K = kruskal_algorithm(G)
arcs_minimaux_P, poids_minimal_P = prim_algorithm(G)

@test poids_minimal_P==poids_minimal_K



### Toutes les instances symétriques (sauf pa561)

# Sauvegardes des chemin du fichier contenant le data
working_directory = pwd()
cd(joinpath(working_directory, "instances", "stsp"))
files_name = readdir()
filter!(e -> e ≠ "pa561.tsp", files_name) # Retrait de l'instance pa561.tsp qui est trop grande pour Kruskal
data_directories = [joinpath(pwd(), file) for file in files_name]
cd(working_directory) # retour au working directory

# Noms et dimensions
headers_ = [read_header(data_dir) for data_dir in data_directories ]
graph_names = [head_["NAME"] for head_ in headers_ ]
graph_dimensioms = [parse(Int, head_["DIMENSION"]) for head_ in headers_ ]

# Liste de graph
graphs = [Graph{Nothing}() for i in 1:length(files_name)]
for i = 1:length(graphs)
    set_name!(graphs[i], graph_names[i])
end

# Ajout des noeuds (le champ data est égal à nothing)
for i = 1:length(graphs)
    for j in 1:graph_dimensioms[i]
     add_node!(graphs[i], Node{Nothing}(nothing, string(j)))
    end
end

# Ajout des arêtes
for i = 1:length(graphs)
    edges, weights = read_edges(headers_[i], data_directories[i]) 
    for j in 1:length(edges)
        local_node1 = Node{Nothing}(nothing, string(edges[j][1]))
        local_node2 = Node{Nothing}(nothing, string(edges[j][2]))
        add_edge!(graphs[i], Edge{Nothing}(local_node1, local_node2, weights[j]))
    end
end

@testset "multiple comparison of final weight for kruskal and prim" begin
for graph in graphs 
  @test kruskal_algorithm(graph)[2] == prim_algorithm(graph)[2]
end
end
