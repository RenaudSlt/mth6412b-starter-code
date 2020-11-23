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

function main_hk(FileName)

    # Dictionnaires des tournées optimales
    best_distances = Dict("bayg29"=>1610,"bays29"=>2020,"brazil58"=>25395,"brg180"=>1950,"dantzig42"=>699,"fri26"=>937, "gr120"=>6942,"gr17"=>2085,"gr21"=>2707,"gr24"=>1272,"gr48"=>5046,"hk48"=>11461,"pa561.tsp"=>2763,"swiss42"=>1273)

    # Dictionnaire des meilleurs paramètres 
    best_parameters_hk = Dict("bayg29"=>["prim", 1, 1.0, "t_step", 1646],"bays29"=>["", 0, 1.0, "", Inf],"brazil58"=>["prim", 1, 1.0, "t_step", 30750],"brg180"=>["", 0, 1.0, "", Inf],"dantzig42"=>["kruskal", 1, 1.0, "t_step", 757],"fri26"=>["kruskal", 1, 1.0, "t_step", 937], "gr120"=>["prim", 1, 1.0, "t_step", 9846],"gr17"=>["kruskal", 1, 1.0, "sub_gradient", 2085],"gr21"=>["prim", 1, 1.0, "t_step", 2707],"gr24"=>["prim", 1, 1.0, "t_step", 1490],"gr48"=>["kruskal", 1, 1.0, "t_step", 5705],"hk48"=>["prim", 1, 1.0, "", 11956],"pa561.tsp"=>["", 0, 1.0, "", Inf],"swiss42"=>["kruskal", 1, 1.0, "t_step", 1499])

    # Sauvegarde du chemin du fichier contenant le data
    working_directory = pwd()

    cd(joinpath(working_directory, "instances", "stsp"))
    data_dir = joinpath(pwd(), FileName)  
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

    println("ALGORITHME HK\n")
    println("instance : ", GraphName)
    best_algo = best_parameters_hk[GraphName][1]
    best_root = get_nodes(G)[best_parameters_hk[GraphName][2]]
    t0 = 1
    best_criteria = best_parameters_hk[GraphName][4]
    
    tour_graph, final_cost, optimal_tour_obtained, tour_obtained, max_iteration = hk_algorithm(G, best_algo, best_root, t, best_criteria)  
    
    println(" ")
    println("Affichage de la tournée : ")
    show(tour_graph)
    println(" ")
    println("Coût final : ", final_cost)
    println("Tournée obtenue : ", optimal_tour_obtained)
    println("Tournée obtenue avec POST-PROCESSING : ", tour_obtained)
    println("Arrêt avant max iteration : ", !max_iteration)
    println(" ")
    println("Meilleurs paramètres : ", best_parameters_hk[GraphName][1], " avec comme noeud racine ", best_parameters_hk[GraphName][2])
    println("Résultat : ", route_weight)
    println("Écart relatif avec une tournée optimale : ", round(100*(best_parameters_hk[GraphName][3] - best_distances[GraphName]) / best_distances[GraphName], digits=2), "%")


    # Affichage de la tournée optimale si possible
    if GraphName in ["bayg29", "bays29", "dantzig42", "gr120", "pa561.tsp"]
        println("\nAffichage de la tournée optimale ...")
        plot_graph_with_tour( string("instances/stsp/", FileName), get_edges(tour_graph) ) 
    end


end