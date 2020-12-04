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

#FileName = "bayg29.tsp"
#FileName = "bays29.tsp"
#FileName = "brazil58.tsp"
#FileName = "brg180.tsp"
#FileName = "dantzig42.tsp"
#FileName = "fri26.tsp"
#FileName = "gr120.tsp"
#FileName = "gr17.tsp"
#FileName = "gr21.tsp"
#FileName = "gr24.tsp"
#FileName = "gr48.tsp"
#FileName = "hk48.tsp"
#FileName = "pa561.tsp"
#FileName = "gr17.tsp"
#FileName = "swiss42.tsp"


""" Fonction qui fait office de programme principal pour la phase 4 
    - La fonction solutionne une instance stsp à partir de deux algorithmes possibles pour le 
      problème de tournée minimale : soit l'algorithme HK ou l'algorithme RSL 
    Input :
        -FileName : un nom de fichier stsp qui représente une instance. 
            Les choix possibles sont :
                "bayg29.tsp", "bays29.tsp", "brazil58.tsp", "brg180.tsp", "dantzig42.tsp", 
                "fri26.tsp", "gr120.tsp", "gr17.tsp", "gr21.tsp", "gr24.tsp", "gr48.tsp", 
                "hk48.tsp", "pa561.tsp", "swiss42.tsp" 
        -algo : le choix de l'algorithme avec les paramètres optimaux obtenus 
            Les choix possibles sont :
                -"hk" : l'algorithme HK, basée sur le fichier fonction hk_algorithm.jl
                -"rsl" : l'algorithm RSL, basée sur le fichier fonction rsl_algorithm.jl
                -"best" : choisit l'algorithme qui a obtenu le plus petit score de tournée minimale pour l'instance

    Output : 
        -Tournée minimale qui est une tournée minimale
        -Coût de la tournée

"""
function main_tsp(FileName, algo)

     # On vérifie que les arguments de type String sont corrects
     if !(algo == "rsl" || algo == "hk" || algo == "best") 
        @error("Invalid input argument for algo argument : ", algo, "\n Possible String inputs are :\n hk \n rsl \n best")
    end

    if !(FileName ∈ ["bayg29.tsp", "bays29.tsp", "brazil58.tsp", "brg180.tsp", "dantzig42.tsp", "fri26.tsp", "gr120.tsp", "gr17.tsp", "gr21.tsp", "gr24.tsp", "gr48.tsp", "hk48.tsp", "pa561.tsp", "swiss42.tsp" ] )
        @error("Unknown filename : ", FileName)
    end


     # Sauvegarde du chemin du fichier contenant le data
     working_directory = pwd()

     cd(joinpath(working_directory, "instances", "stsp"))
     data_dir = joinpath(pwd(), FileName)  
     cd(working_directory)  # retour au working directory
 
     # Nom et dimension
     headers_ = read_header(data_dir)
     GraphName = headers_["NAME"]
     dim = parse(Int, headers_["DIMENSION"])


    # Dictionnaires des tournées optimales
    best_distances = Dict("bayg29"=>1610,"bays29"=>2020,"brazil58"=>25395,"brg180"=>1950,"dantzig42"=>699,"fri26"=>937, "gr120"=>6942,"gr17"=>2085,"gr21"=>2707,"gr24"=>1272,"gr48"=>5046,"hk48"=>11461,"pa561.tsp"=>2763,"swiss42"=>1273)

    # Dictionnaire des meilleurs paramètres pour hk 
    best_parameters_hk = Dict("bayg29"=>["kruskal", 27, 1.0, "t_step", 1662],"bays29"=>["prim", 9, 1.0, "t_step", 2048],"brazil58"=>["prim", 1, 1.0, "t_step", 26652],"brg180"=>["", 0, 1.0, "", Inf],"dantzig42"=>["prim", 20, 1.0, "t_step", 803.0],"fri26"=>["kruskal", 1, 1.0, "t_step", 937], "gr120"=>["prim", 1, 1.0, "t_step", 9846],"gr17"=>["kruskal", 1, 1.0, "sub_gradient", 2085],"gr21"=>["prim", 1, 1.0, "t_step", 2707],"gr24"=>["prim", 24, 1.0, "t_step", 1314.0],"gr48"=>["kruskal", 40, 1.0, "t_step", 5563],"hk48"=>["prim", 1, 1.0, "t_step", 11956],"pa561.tsp"=>["", 0, 1.0, "", Inf],"swiss42"=>["kruskal", 5, 1.0, "t_step", 1273.0])
    #best_parameters_hk["dantzig42"]=["prim", 1, 1.0, "t_step", 803.0]
    #best_parameters_hk["pa561.tsp"]=["prim", 1, 1.0, "t_step", Inf]
    # Dictionnaires des meilleurs paramètres pour rsl
    best_parameters_rsl = Dict("brazil58" => ["prim", 46, 28121],"gr17" => ["kruskal", 7, 2210],"bayg29" => ["kruskal", 17, 2014],"gr120" => ["kruskal", 104, 8982],"swiss42" => ["kruskal", 32, 3182],"brg180" => ["prim", 130, 75460],"pa561.tsp" => ["prim", 450, 3855],"gr21" => ["prim", 13, 2968],"dantzig42" => ["prim", 4, 890],"fri26" => ["prim", 2, 1073],"hk48" => ["kruskal", 20, 13939],"gr48" => ["prim", 39, 6680],"gr24" => ["prim", 13, 1519],"bays29" => ["kruskal", 14, 4626])


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

    if algo == "best"
        if best_parameters_hk[get_name(G)][5] <= best_parameters_rsl[get_name(G)][3]
            algo = "hk"
        else
            algo = "rsl"
        end
    end



    if algo == "hk"
        println("ALGORITHME HK\n")
        println("instance : ", GraphName)
        best_algo = best_parameters_hk[GraphName][1]
        best_root = get_nodes(G)[best_parameters_hk[GraphName][2]]
        t0 = 1.0
        best_criteria = best_parameters_hk[GraphName][4]
        
        tour_graph, final_cost, optimal_tour_obtained, tour_obtained, max_iteration = hk_algorithm(G, best_algo, best_root, t0, best_criteria)  
        
        println(" ")
        println("Affichage de la tournée : ")
        show(tour_graph)
        println(" ")
        println("Coût final : ", final_cost)
        println("Tournée obtenue avant POST-PROCESSING : ", optimal_tour_obtained)
        println("Tournée obtenue avec POST-PROCESSING : ", tour_obtained)
        println("Arrêt avant max iteration : ", !max_iteration)
        println(" ")
        println("Meilleurs paramètres : ", best_parameters_hk[GraphName][1], " avec comme noeud racine ", best_parameters_hk[GraphName][2], " et comme critère d'arrêt ", best_parameters_hk[GraphName][4])
        println("Écart relatif avec une tournée optimale : ", round(100*abs(final_cost -best_distances[GraphName]) / best_distances[GraphName] , digits=2), "%")


         # Affichage de la tournée optimale si possible
         if GraphName in ["bayg29", "bays29", "dantzig42", "gr120"]
            println("\nAffichage de la tournée optimale ...")
            display(plot_graph_with_tour( string("instances/stsp/", FileName), get_edges(tour_graph) ))
        end


    elseif algo == "rsl"

        println("ALGORITHME RSL\n")
        println("instance : ", GraphName)
        best_algo = best_parameters_rsl[GraphName][1]
        best_root = get_nodes(G)[best_parameters_rsl[GraphName][2]]
        route_nodes, route_edges, route_weight = rsl_algorithm(G, best_algo, best_root)
        for edge in route_edges
            show(edge)
        end
        println("meilleurs paramètres : ", best_parameters_rsl[GraphName][1], " avec comme noeud racine ", best_parameters_rsl[GraphName][2])
        println("résultat : ", route_weight)
        println("écart relatif avec une tournée optimale : ", round(100*(route_weight - best_distances[GraphName]) / best_distances[GraphName], digits=2), "%")

        for node in route_nodes
            show(node)
        end

        # Affichage de la tournée optimale si possible
        if GraphName in ["bayg29", "bays29", "dantzig42", "gr120"]
            println("\nAffichage de la tournée optimale ...")
            display(plot_graph_with_tour( string("instances/stsp/", FileName), route_edges ))
        end
        
    end

end

