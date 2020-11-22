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
best_distances = Dict("bayg29"=>1610,"bays29"=>2020,"brazil58"=>25395,"brg180"=>1950,"dantzig42"=>699,"fri26"=>937, "gr120"=>6942,"gr17"=>2085,"gr21"=>2707,"gr24"=>1272,"gr48"=>5046,"hk48"=>11461,"pa561.tsp"=>2763,"swiss42"=>1273)

# Paramètres des meilleures tournées trouvées
best_parameters_rsl = Dict("bayg29"=>["",0,Inf],"bays29"=>["",0,Inf],"brazil58"=>["",0,Inf],"brg180"=>["",0,Inf],"dantzig42"=>["",0,Inf],"fri26"=>["",0,Inf], "gr120"=>["",0,Inf],"gr17"=>["",0,Inf],"gr21"=>["",0,Inf],"gr24"=>["",0,Inf],"gr48"=>["",0,Inf],"hk48"=>["",0,Inf],"pa561.tsp"=>["",0,Inf],"swiss42"=>["",0,Inf])

"""
k = 3
algo = best_parameters_rsl[get_name(graphs[k])][1]
root = get_nodes(graphs[k])[best_parameters_rsl[get_name(graphs[k])][2]]
a,b, distance = rsl_algorithm(graphs[k], algo, root )
println(distance)
println("\n")
"""
# Tests
#G = graphs[1] # bayg29
#G = graphs[2] # bays29
#G = graphs[3] # brazil58
#G = graphs[5] # dantzig42
#G = graphs[6] # fri26

# Pour les petites instance (n<80), on test tous les noeuds
for i in [1,2,3,5,6,8,9,10,11,12,14]
  min = Inf # meilleure tournée à date
  for algo in ["kruskal", "prim"]
    for j in 1:nb_nodes(graphs[i])
      villes, trajets, distance = rsl_algorithm(graphs[i], algo, get_nodes(graphs[i])[j])
      # Si amélioration, on mémorise le noeud racine, l'algorithme (kruskal ou Prim) et le poids 
      if distance < min
        min = distance
        best_parameters_rsl[get_name(graphs[i])][1] = algo
        best_parameters_rsl[get_name(graphs[i])][2] = get_index(get_nodes(graphs[i])[j])
        best_parameters_rsl[get_name(graphs[i])][3] = distance
      end
    end
  end
end

best_parameters_rsl = Dict("brazil58" => ["prim", 46, 28121],"gr17" => ["kruskal", 7, 2210],"bayg29" => ["kruskal", 17, 2014],"gr120" => ["kruskal", 104, 8982],"swiss42" => ["kruskal", 32, 1587],"brg180" => ["prim", 130, 75460],"pa561.tsp" => ["prim", 450, 3855],"gr21" => ["prim", 13, 2968],"dantzig42" => ["prim", 4, 890],"fri26" => ["prim", 2, 1073],"hk48" => ["kruskal", 20, 13939],"gr48" => ["prim", 39, 6680],"gr24" => ["prim", 13, 1519],"bays29" => ["kruskal", 14, 2313])

# Pour les grandes instance (n>80), on test aléatoirement
for i in [4,7,13]
  min = Inf # meilleure tournée à date
  for algo in ["kruskal", "prim"]    
    for j in 1:nb_nodes(graphs[i])
      # Si Kruskal, 1 noeud sur 10 pour br180
      if algo == "kruskal" && i == 4 && j%10 != 0
        continue
      end
      # Si Kruskal, 1 noeud sur 8 pour gr120
      if algo == "kruskal" && i == 7 && j%8 != 0
        continue
      end
      # Jamais Kruskal
      # Si Prim, 1 noeud sur 50 pour pa561
      if (algo == "kruskal" || j%50!=0) && i == 13
        continue
      end
      villes, trajets, distance = rsl_algorithm(graphs[i], algo, get_nodes(graphs[i])[j])
      # Si amélioration, on mémorise le noeud racine, l'algorithme (kruskal ou Prim) et le poids 
      if distance < min
        min = distance
        best_parameters_rsl[get_name(graphs[i])][1] = algo
        best_parameters_rsl[get_name(graphs[i])][2] = get_index(get_nodes(graphs[i])[j])
        best_parameters_rsl[get_name(graphs[i])][3] = distance
      end
    end
  end
end

println(best_parameters_rsl)
println("\n")
println(best_parameters_rsl["brg180"])
println(best_parameters_rsl["gr120"])
println(best_parameters_rsl["pa561.tsp"])

Any["prim", 130, 75460]
Any["kruskal", 104, 8982]
Any["prim", 450, 3855]

best_parameters_rsl = Dict("brazil58" => ["prim", 46, 28121],"gr17" => ["kruskal", 7, 2210],"bayg29" => ["kruskal", 17, 2014],"gr120" => ["kruskal", 104, 8982],"swiss42" => ["kruskal", 32, 3182],"brg180" => ["prim", 130, 75460],"pa561.tsp" => ["prim", 450, 3855],"gr21" => ["prim", 13, 2968],"dantzig42" => ["prim", 4, 890],"fri26" => ["prim", 2, 1073],"hk48" => ["kruskal", 20, 13939],"gr48" => ["prim", 39, 6680],"gr24" => ["prim", 13, 1519],"bays29" => ["kruskal", 14, 4626])
