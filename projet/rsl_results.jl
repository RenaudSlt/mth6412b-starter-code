include("read_stsp.jl")
include("node.jl")
include("edge.jl")
include("graph.jl")
include("markednode.jl")
include("nodetree.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("rsl_algorithm.jl")

### Se placer dans le répertoire 'mth6412b-starter-code ###

# Sauvegardes des chemin du fichier contenant le data
working_directory = pwd()
cd(joinpath(working_directory, "instances", "stsp"))
files_name = readdir()
data_directories = [joinpath(pwd(), file) for file in files_name]
cd(working_directory) # retour au working directory

# Noms et dimensions
headers_ = [read_header(data_dir) for data_dir in data_directories ]
graph_names = [head_["NAME"] for head_ in headers_ ]
graph_dimensions = [parse(Int, head_["DIMENSION"]) for head_ in headers_ ]

# Liste de graph
graphs = [Graph{Nothing}() for i in 1:length(files_name)]
for i = 1:length(graphs)
    set_name!(graphs[i], graph_names[i])
end

# Ajout des noeuds (le champ data est égal à nothing)
for i = 1:length(graphs)
    for j in 1:graph_dimensions[i]
     add_node!(graphs[i], Node{Nothing}(nothing, name_=string(j), index_=j))
    end
end

# Ajout des arêtes
for i = 1:length(graphs)
  local edges, weights = read_edges(headers_[i], data_directories[i]) 
  for j in 1:length(edges)
    node1_name = string(edges[j][1])
    node2_name = string(edges[j][2])
    idx1 = findfirst(x -> get_name(x)==node1_name, get_nodes(graphs[i]))
    idx2 = findfirst(x -> get_name(x)==node2_name, get_nodes(graphs[i]))
    
    temp_edge = Edge{Nothing}(get_nodes(graphs[i])[idx1], get_nodes(graphs[i])[idx2], weights[j])

    flag_symetric = false
    # Swiss 42 et Bays29 sont les seules instances avec des arêtes en double
    if get_name(graphs[i]) == "swiss42" || get_name(graphs[i]) == "bays29"
      for edge_in_G in get_edges(graphs[i])
          if is_symetric(edge_in_G, temp_edge)
            flag_symetric = true
          end
      end
    end

    # On évite les boucles et les arcs symétriques (NON-ORIENTÉ)
    if (get_nodes(graphs[i])[idx1] != get_nodes(graphs[i])[idx2]) && !flag_symetric
      add_edge!(graphs[i], temp_edge)
    end 
  end
end


# Poids des tournées optimales
best_distances = Dict("bayg29"=>1610,"bays29"=>2020,"brazil58"=>25395,"brg180"=>1950,"dantzig42"=>699,"fri26"=>937,"gr17"=>2085,"gr21"=>2707,"gr24"=>1272,"gr48"=>5046,"gr120"=>6942,"hk48"=>11461,"pa561.tsp"=>2763,"swiss42"=>1273)

# Tests avec Kruskal
println("KRUSKAL\n")
for i = 1:length(graphs)
  get_name(graphs[i]) == "pa561.tsp" && continue  # Kruskal ne résout pas l'instance pa561
  route_nodes, route_edges, route_weight = rsl_algorithm(graphs[i], "kruskal", get_nodes(graphs[i])[1])
  println(get_name(graphs[i]), ", ")
  println("poids trouvé : ", route_weight, ", ")
  println("poids optimal : ", best_distances[get_name(graphs[i])], ", ")
  println(route_weight, (route_weight <= 2*best_distances[get_name(graphs[i])]) ? " <= " : " > ", "2 * ", best_distances[get_name(graphs[i])], (route_weight <= 2*best_distances[get_name(graphs[i])]) ? " " : "  !!! ", "\n")
end

println("\n")
println("\n")

# Tests avec Prim
println("PRIM\n")
for i = 1:length(graphs)
  route_nodes, route_edges, route_weight = rsl_algorithm(graphs[i], "prim", get_nodes(graphs[i])[1])
  println(get_name(graphs[i]), ", ")
  println("poids trouvé : ", route_weight, ", ")
  println("poids optimal : ", best_distances[get_name(graphs[i])], ", ")
  println(route_weight, (route_weight <= 2*best_distances[get_name(graphs[i])]) ? " <= " : " > ", "2 * ", best_distances[get_name(graphs[i])], (route_weight <= 2*best_distances[get_name(graphs[i])]) ? " " : "  !!! ", "\n")
end