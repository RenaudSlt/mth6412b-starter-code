include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("rsl_algorithm.jl")
include("hk_algorithm.jl")
include("prim_algorithm.jl")

### Se placer dans le répertoire 'mth6412b-starter-code' ###

# Choix de l'instance
#FileName = "bayg29.tsp"   # upper row
#FileName = "gr17.tsp"     # lower diag row
FileName = "swiss42.tsp"  # full matrix

# Sauvegarde du chemin du fichier contenant le data
working_directory = pwd()

cd(joinpath(working_directory, "instances", "stsp"))
data_dir = joinpath(pwd(), FileName)  # NOTE : devrait fonctionner avec Windows et Unix, cependant Unix pas testé!!! 
cd(working_directory)  # retour au working directory

# Nom et dimension
headers_ = read_header(data_dir)
GraphName = headers_["NAME"]
dim = parse(Int, headers_["DIMENSION"])

# Création du graphe vide
G = Graph{Nothing}()
set_name!(G, GraphName)

# Ajout des noeuds (le champ data est égal à nothing)
for i in 1:dim
  add_node!(G, Node{Nothing}(nothing, name_=string(i), index_=i))
end

# Ajout des arêtes
edges_, weights_ = read_edges(headers_, data_dir) 
for j in 1:length(edges_)

  node1_name = string(edges_[j][1])
  node2_name = string(edges_[j][2])
  idx1 = findfirst(x -> get_name(x)==node1_name, get_nodes(G))
  idx2 = findfirst(x -> get_name(x)==node2_name, get_nodes(G))
  
  if get_nodes(G)[idx1] != get_nodes(G)[idx2]
    add_edge!(G, Edge{Nothing}(get_nodes(G)[idx1], get_nodes(G)[idx2], weights_[j]))
  end

end

# Affichage du graphe
#show(G)

# Algorithme de Kruskal
#kruskal_algorithm(G)

# Algorithme de Prim
#noeuds, poids, noeuds_marques = prim_algorithm(G)

#source = 4
#villes1, trajets1, distance1 = rsl_algorithm(G, "kruskal", get_nodes(G)[source])
#villes2, trajets2, distance2 = rsl_algorithm(G, "prim", get_nodes(G)[source])

#println("\nDistance K : ", distance1)
#println("\nDistance P : ", distance2)


# Test construire matrix
#build_matrix!(G)
#print(get_matrix(G))

# Test enlever noeud et les aretes adjacentes
#remove_node_from_graph(G, node=get_nodes(G)[2])
#show(G)
#node = get_nodes(G)[1]

# Test HK algorithm
# Critère d'arrêt "period_length" "t_step" "sub_gradient"

tour_graph, final_cost, optimal_tour_obtained, tour_obtained = hk_algorithm(G, "kruskal", get_nodes(G)[2], 1.0, "t_step")  
#println("Tournée bon coût:")
show(tour_graph)
println(" ") #print("\n")
println("Coût final : ", final_cost)
println("Tournée obtenue : ", optimal_tour_obtained)
println("Tournée obtenue avec POST-PROCESSING : ", tour_obtained)

v = get_degrees(tour_graph)
for i = 1:nb_nodes(tour_graph)
  println("noeud ", i, " degree :", v[i]-2)
end

