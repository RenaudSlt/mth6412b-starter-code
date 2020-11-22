include("read_stsp.jl")
include("node.jl")
include("edge.jl")
include("graph.jl")
include("markedNode.jl")
include("nodeTree.jl")
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
    local edges, weights = read_edges(headers_[i], data_directories[i]) 
    for j in 1:length(edges)
        local_node1 = Node{Nothing}(nothing, string(edges[j][1]))
        local_node2 = Node{Nothing}(nothing, string(edges[j][2]))
        add_edge!(graphs[i], Edge{Nothing}(local_node1, local_node2, weights[j]))
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