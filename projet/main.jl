include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("rsl_algorithm.jl")
include("hk_algorithm.jl")

### Se placer dans le répertoire 'mth6412b-starter-code' ###

# Choix de l'instance
#FileName = "gr17.tsp"     # lower diag row  ok
#FileName = "bayg29.tsp"   # upper row  ok
#FileName = "swiss42.tsp"  # full matrix ok
#FileName = "gr21.tsp" ok
#FileName = "gr24.tsp" ok
#FileName = "gr48.tsp" ok
#FileName = "gr120.tsp"
#FileName = "brazil58.tsp"
#FileName = "brg180.tsp"
#FileName = "dantzig42.tsp"
#FileName = "fri26.tsp"
#FileName = "hk48.tsp"
#FileName = "bays29.tsp"
FileName = "pa561.tsp"




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
  
  temp_edge = Edge{Nothing}(get_nodes(G)[idx1], get_nodes(G)[idx2], weights_[j])

  flag_symetric = false
  # Swiss 42 et Bays29 sont les seules instances avec des arêtes en double
  if get_name(G) == "swiss42" || get_name(G) == "bays29"
    for edge_in_G in get_edges(G)
        if is_symetric(edge_in_G, temp_edge)
          flag_symetric = true
        end
    end
  end

  # On évite les boucles et les arcs symétriques (NON-ORIENTÉ)
  if (get_nodes(G)[idx1] != get_nodes(G)[idx2]) && !flag_symetric
    add_edge!(G, temp_edge)
  end

end


best_distances = Dict("bayg29"=>1610,"bays29"=>2020,"brazil58"=>25395,"brg180"=>1950,"dantzig42"=>699,"fri26"=>937, "gr120"=>6942,"gr17"=>2085,"gr21"=>2707,"gr24"=>1272,"gr48"=>5046,"hk48"=>11461,"pa561.tsp"=>2763,"swiss42"=>1273)



tour_graph, final_cost, optimal_tour_obtained, tour_obtained, max_iteration = hk_algorithm(G, "prim", get_nodes(G)[1], 1.0, "t_step")  
#println("Tournée bon coût:")
show(tour_graph)
println(" ") #print("\n")
println("Coût final : ", final_cost)
println("Tournée obtenue : ", optimal_tour_obtained)
println("Tournée obtenue avec POST-PROCESSING : ", tour_obtained)
println("Arrêt avant max iteration : ", !max_iteration)

v = get_degrees(tour_graph)
for i = 1:nb_nodes(tour_graph)
  println("noeud ", i, " degree :", v[i]-2)
end

