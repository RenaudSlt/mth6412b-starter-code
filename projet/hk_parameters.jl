include("read_stsp.jl")
include("node.jl")
include("edge.jl")
include("graph.jl")
include("markednode.jl")
include("nodetree.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("hk_algorithm.jl")


""" Fonction d'utilité pour enregistrer les résultats dans un fichier .txt"""
function log_hk(graph, mst, stop_criterion, node)
    
    # On construit le nom du fichier .txt
    node_index = get_index(node)
    graph_name = get_name(graph)
    file_name = string(graph_name, "_", mst, "_", stop_criterion, "_", node_index, ".txt")

    # On lance la fonction 
    tour_graph, final_cost, optimal_tour_obtained, tour_obtained, max_iteration, at_least_one_improvement = hk_algorithm(graph, mst, node, 1.0, stop_criterion)  
    
    
    # On se déplace dans le fichier pour les logs pour enregistrer les résultats, puis on revient au working directory
    cd("projet")
    cd("logs_hk_algorithm")


    file = open(file_name, "w")
    #show(tour_graph)
    v = get_degrees(tour_graph)
    println(file, "Degrés des noeuds :\n")
    for i = 1:nb_nodes(tour_graph)
        println(file, "noeud ", i, " degree :", v[i]-2)
    end
    
    println(file, " ") #print("\n")
    println(file, "Coût final : ", final_cost)
    println(file, "Tournée obtenue : ", optimal_tour_obtained)
    println(file, "Tournée obtenue avec POST-PROCESSING : ", tour_obtained)
    println(file, "Arrêt avant max iteration : ", !max_iteration)
    println(file, "Au moins une amélioration : ", at_least_one_improvement)
    close(file)
    cd("..")
    cd("..")
    return final_cost, optimal_tour_obtained, tour_obtained

end


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

# Paramètres des meilleures tournées trouvées : [Kruskal/Prim, node_index, t0, stop_criterion, tour_weight]
best_parameters_hk = Dict("bayg29"=>["kruskal", 27, 1.0, "t_step", 1642],"bays29"=>["prim", 1, 1.0, "t_step", 2177],"brazil58"=>["prim", 1, 1.0, "t_step", 30750],"brg180"=>["", 0, 1.0, "", Inf],"dantzig42"=>["kruskal", 1, 1.0, "t_step", 757],"fri26"=>["kruskal", 1, 1.0, "t_step", 937], "gr120"=>["prim", 1, 1.0, "t_step", 9846],"gr17"=>["kruskal", 1, 1.0, "sub_gradient", 2085],"gr21"=>["prim", 1, 1.0, "t_step", 2707],"gr24"=>["prim", 24, 1.0, "t_step", 1278],"gr48"=>["kruskal", 1, 1.0, "t_step", 5705],"hk48"=>["prim", 1, 1.0, "", 11956],"pa561.tsp"=>["", 0, 1.0, "", Inf],"swiss42"=>["kruskal", 1, 1.0, "t_step", 1499])


# graphs[1] : bayg29 
# graphs[2] : bays29
# graphs[3] : brazil58
# graphs[4] : brg180 : très lourd
# graphs[5] : dantzig42
# graphs[6] : fri26 : OKAY, deja optimisé
# graphs[7] : gr120
# graphs[8] : gr17 : OKAY, deja optimisé
# graphs[9] : gr21 : OKAY, deja optimisé
# graphs[10] : gr24 : OKAY
# graphs[11] : gr48
# graphs[12] : hk48
# graphs[13] : pa561.tsp : très lourd
# graphs[14] : swiss42


for graph in [graphs[2]]

    min = Inf # meilleure tournée à date
    graph_name = get_name(graph)
    println(graph_name)
    println(best_parameters_hk[graph_name])
    #continue

    # Optimalité atteinte pour ces trois instances, aucune search nécessaire
    if graph_name == "gr17" || graph_name == "gr21" || graph_name == "fri26" 
        continue 

    # Ces graphs sont très long à résoudre : À TESTER DE MANIÈRE ISOLÉE
    #elseif graph_name == "pa561.tsp" || graph_name == "brg180"
    elseif graph_name == "pa561.tsp"    
        continue 

    elseif nb_nodes(graph) < 30
        for mst in ["prim", "kruskal"]
            for stop_criterion in ["t_step","period_length","sub_gradient"]
                for (idx,node) in enumerate(get_nodes(graph)) 
                    # On test un noeud sur 3
                    if idx==1 || idx%3==0
                        final_cost, optimal_tour_obtained, tour_obtained = log_hk(graph, mst, stop_criterion, node)
                        
                        if optimal_tour_obtained || tour_obtained
                            if final_cost < min
                                min = final_cost
                                #["prim", 1, 1.0, "t_step", 1646]
                                best_parameters_hk[graph_name][1] = mst
                                best_parameters_hk[graph_name][2] = get_index(node)
                                best_parameters_hk[graph_name][3] = 1.0
                                best_parameters_hk[graph_name][4] = stop_criterion
                                best_parameters_hk[graph_name][5] = min
                            end
                        end

                    end
                end
            end 
        end

    # On enlève sub_gradient comme critère d'arrêt, puis on prend un essai juste les noeuds pairs comme source
    elseif nb_nodes(graph) >= 30 && nb_nodes(graph) < 60
        for mst in ["prim", "kruskal"]
            for stop_criterion in ["t_step","period_length"]
                for (idx,node) in enumerate(get_nodes(graph))
                    # On test un noeud sur 5
                    if idx==1 || idx%5==0
                        final_cost, optimal_tour_obtained, tour_obtained =log_hk(graph, mst, stop_criterion, node)
                        
                        if optimal_tour_obtained || tour_obtained
                            if final_cost < min
                                min = final_cost
                                #["prim", 1, 1.0, "t_step", 1646]
                                best_parameters_hk[graph_name][1] = mst
                                best_parameters_hk[graph_name][2] = get_index(node)
                                best_parameters_hk[graph_name][3] = 1.0
                                best_parameters_hk[graph_name][4] = stop_criterion
                                best_parameters_hk[graph_name][5] = min
                            end
                        end
                    
                    end
                end
            end
        end

    # On enlève sub_gradient comme critère d'arrêt et on enlève kruskal comme MST, puis on essaie un noeud sur 4
    elseif nb_nodes(graph) > 100 
        mst = "prim"
        for stop_criterion in ["t_step","period_length"]
            for (idx,node) in enumerate(get_nodes(graph))
                # On teste un noeud sur 10
                if idx==1 || idx%10==0
                    final_cost, optimal_tour_obtained, tour_obtained =log_hk(graph, mst, stop_criterion, node)
                
                    if optimal_tour_obtained || tour_obtained
                        if final_cost < min
                            min = final_cost
                            #["prim", 1, 1.0, "t_step", 1646]
                            best_parameters_hk[graph_name][1] = mst
                            best_parameters_hk[graph_name][2] = get_index(node)
                            best_parameters_hk[graph_name][3] = 1.0
                            best_parameters_hk[graph_name][4] = stop_criterion
                            best_parameters_hk[graph_name][5] = min
                        end
                    end
                
                end
            end
        end

    end
    println( best_parameters_hk[graph_name] )
end
