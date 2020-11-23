include("read_stsp.jl")
include("node.jl")
include("edge.jl")
include("graph.jl")
include("markedNode.jl")
include("nodeTree.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("hk_algorithm.jl")

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
best_parameters_hk = Dict("bayg29"=>["", 0, 1.0, "", Inf],"bays29"=>["", 0, 1.0, "", Inf],"brazil58"=>["", 0, 1.0, "", Inf],"brg180"=>["", 0, 1.0, "", Inf],"dantzig42"=>["", 0, 1.0, "", Inf],"fri26"=>["", 0, 1.0, "", Inf], "gr120"=>["", 0, 1.0, "", Inf],"gr17"=>["", 0, 1.0, "", Inf],"gr21"=>["", 0, 1.0, "", Inf],"gr24"=>["", 0, 1.0, "", Inf],"gr48"=>["", 0, 1.0, "", Inf],"hk48"=>["", 0, 1.0, "", Inf],"pa561.tsp"=>["", 0, 1.0, "", Inf],"swiss42"=>["", 0, 1.0, "", Inf])


for graph in graphs[7]
    
    if nb_nodes(graph) < 30
        for mst in ["prim", "kruskal"]
            for stop_criterion in ["t_step","period_length","sub_gradient"]
                for (idx,node) in enumerate(get_nodes(graph)[1]) # WARNING DELETE!
                    print_result(graph, mst, stop_criterion, node)
                end
            end 
        end

    # On enlève sub_gradient comme critère d'arrêt, puis on prend un essai juste les noeuds pairs comme source
    elseif nb_nodes(graphs[i]) >= 30 && nb_nodes(graphs[i]) < 100
        for mst in ["prim", "kruskal"]
            for stop_criterion in ["t_step","period_length"]
                for (idx,node) in enumerate(get_nodes(graph))
                    if idx==1 || idx%2==0
                        print_result(graph, mst, stop_criterion, node)
                    end
                end
            end
        end

    # On enlève sub_gradient comme critère d'arrêt et on enlève kruskal comme MST, puis on essaie un noeud sur 4
    elseif nb_nodes(graphs[i]) > 100 && nb_nodes(graphs[i]) < 500
        mst = "prim"
        for stop_criterion in ["t_step","period_length"]
            for (idx,node) in enumerate(get_nodes(graph))
                if idx==1 || idx%4==0
                    print_result(graph, mst, stop_criterion, node)
                end
            end
        end
    
    # On enlève sub_gradient comme critère d'arrêt et on enlève kruskal comme MST, puis on essaie un noeud sur 8
    else
        mst = "prim"
        for stop_criterion in ["t_step","period_length"]
            for (idx,node) in enumerate(get_nodes(graph))
                if idx==1 || idx%8==0
                    print_result(graph, mst, stop_criterion, node)
                end
            end
        end

    end

end




""" Fonction d'utilité enregistrer les résultats dans un fichier .txt"""
function print_result(graph, mst, stop_criterion, node)
    node_index = get_index(node)
    graph_name = get_name(graph)
    file_name = string(graph_name, "_", mst, "_", stop_criterion, "_", node_index, ".txt")

    tour_graph, final_cost, optimal_tour_obtained, tour_obtained, max_iteration = hk_algorithm(graph, mst, node, 1.0, stop_criterion)  
    cd("logs_hk_algorithm")
    file = open(file_name, "w")
    show(tour_graph)
    println(" ") #print("\n")
    println("Coût final : ", final_cost)
    println("Tournée obtenue : ", optimal_tour_obtained)
    println("Tournée obtenue avec POST-PROCESSING : ", tour_obtained)
    println("Arrêt avant max iteration : ", !max_iteration)
    close(file)
    cd("..")

end