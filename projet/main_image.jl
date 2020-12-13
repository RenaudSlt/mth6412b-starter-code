include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("rsl_algorithm.jl")
include("hk_algorithm.jl")
include(joinpath("..","shredder-julia","bin","tools.jl"))

### Se placer dans le répertoire 'mth6412b-starter-code' ###


function main_image(FileName::String, algo::String, root_number::Union{String,Int})

    if !(FileName ∈ ["abstract-light-painting","alaska-railroad","blue-hour-paris","lower-kananaskis","marlet2-radio-board","nikos-cat","pizza-food-wallpaper","the-enchanted-garden","tokyo-skytree-aerial"] )
        @error("Unknown filename : ", FileName)
    end

    if (typeof(root_number)!=String) && (root_number>600)
      @error("root_number must be under 600 : ", root_number)
    end

    # Meilleurs paramètres pour Prim et Kruskal
    best_parameters_rsl_prim = Dict("abstract-light-painting"=>["prim",510,12393175],"alaska-railroad"=>["prim",100,7822262],"blue-hour-paris"=>["prim",200,4063554],"lower-kananaskis-lake"=>["prim",480,4300317],"marlet2-radio-board"=>["prim",110,9129699],"nikos-cat"=>["prim",20,3127465],"pizza-food-wallpaper"=>["prim",410,5136087],"the-enchanted-garden"=>["prim",30,20010832],"tokyo-skytree-aerial"=>["prim",20,13654601],)
    best_parameters_rsl_kruskal = Dict("abstract-light-painting"=>["kruskal",400,12359023],"alaska-railroad"=>["kruskal",7779637,600],"blue-hour-paris"=>["kruskal",200,3989701],"lower-kananaskis-lake"=>["kruskal",200,4254147],"marlet2-radio-board"=>["kruskal",200,8997767],"nikos-cat"=>["kruskal",200,3077214],"pizza-food-wallpaper"=>["kruskal",400,5100665],"the-enchanted-garden"=>["kruskal",600,19976343],"tokyo-skytree-aerial"=>["kruskal",0,Inf],)

    # Sauvegarde du chemin du fichier contenant le data
    working_directory = pwd()
    cd(joinpath(working_directory, "shredder-julia", "tsp", "instances"))
    data_dir = joinpath(pwd(), string(FileName, ".tsp"))  
    cd(working_directory)  # retour au working directory
 
    # Nom et dimension
    headers_ = read_header(data_dir)
    GraphName = headers_["NAME"]

    dim = parse(Int, headers_["DIMENSION"])

    # Création du graphe vide
    G = Graph{Int}()
    set_name!(G, GraphName)

    # Ajout des noeuds
    for i in 0:(dim-1)
      add_node!(G, Node{Int}(i, name_=string(i), index_=i))
    end

    # Ajout des arêtes
    edges_, weights_ = read_edges(headers_, data_dir) 
    for j in 1:length(edges_)
        node1_name = string(edges_[j][1]-1)
        node2_name = string(edges_[j][2]-1)
        idx1 = findfirst(x -> get_name(x)==node1_name, get_nodes(G))
        idx2 = findfirst(x -> get_name(x)==node2_name, get_nodes(G))
        temp_edge = Edge{Int}(get_nodes(G)[idx1], get_nodes(G)[idx2], (weights_[j]==0) ? 10^6 : weights_[j])
        # On évite les boucles
        if (get_nodes(G)[idx1] != get_nodes(G)[idx2])
            add_edge!(G, temp_edge)
        end
    end

    println("\nALGORITHME RSL\n")
    println("instance : ", FileName)

    # Sélection des paramètres
    selected_algo = algo
    if algo == "best"
      if best_parameters_rsl_prim[FileName][3] <= best_parameters_rsl_kruskal[FileName][3]
        selected_algo = "prim"
      else
        selected_algo = "kruskal"
      end
    end

    selected_root_number = root_number
    if root_number == "best"
      if selected_algo == "prim"
        selected_root_number = best_parameters_rsl_prim[FileName][2]
      else
        selected_root_number = best_parameters_rsl_kruskal[FileName][2]
      end
    end
    selected_root = get_nodes(G)[selected_root_number]
    
    # Affichage des paramètres
    if (algo == "best") && (root_number == "best")
      if selected_algo == "prim"
        println("meilleurs paramètres : ", best_parameters_rsl_prim[FileName][1], " avec comme noeud racine ", best_parameters_rsl_prim[FileName][2])
      else
        println("meilleurs paramètres : ", best_parameters_rsl_kruskal[FileName][1], " avec comme noeud racine ", best_parameters_rsl_kruskal[FileName][2])
      end
    else
      println("paramètres : ", selected_algo, " avec comme noeud racine ", selected_root_number)
    end

    # Exécution de l'algorithme RSL
    route_nodes, route_edges, route_weight = rsl_algorithm(G, selected_algo, selected_root)
      
    # Affichage du résultat
    println("\npoids de la tournée (avec noeud 0) : ", route_weight)
    println("poids du chemin (sans noeud 0) : ", route_weight - 2*10^6)

    ### Transformation de la tournée en fichier .tour
    # Transformer route_nodes en array
    tour = Array{Int64}(undef, 1)
    for node in route_nodes
      push!(tour, get_data(node))
    end
    # Suppression de l'éventuel outlier
    # (Patch d'un problème non résolu : parfois un 602e élément aberrant est ajouté au vecteur)
    for i in 1:length(tour)
      if tour[i]>601
        deleteat!(tour, i)
        break
      end
    end
    # Permuter circulairement les éléments de tour jusqu'à obtenir le noeud 0 en premier
    while tour[1] != 0
      tour = vcat(tour[2:end], tour[1])
    end
    # Supression d'un éventuel 602-ième élément
    while length(tour) > 601
      println("IN 602  !!")
      pop!(tour)
    end
    # Sauvegarde au bon format
    tour_filename = joinpath("shredder-julia", "tsp", "reconstructed_tours", string(FileName, "_", route_weight-2*10^6, "_root-is-", selected_root_number, ".tour"))
    write_tour(tour_filename, tour, Float32(route_weight))

    ### Reconstruction de l'image
    input_name = joinpath("shredder-julia", "images", "shuffled", string(FileName, ".png"))
    output_name = joinpath("shredder-julia", "images", "reconstructed", string(FileName, "_", route_weight-2*10^6, "_root-is-", selected_root_number, ".png"))
    reconstruct_picture(tour_filename, input_name, output_name; view=true)

    println("\nfichiers créés : ")
    println(joinpath("shredder-julia", "tsp", "reconstructed_tours", string(FileName, "_", route_weight-2*10^6, "_root-is-", selected_root_number, ".tour")))
    println(joinpath("shredder-julia", "images", "reconstructed", string(FileName, "_", route_weight-2*10^6, "_root-is-", selected_root_number, ".png")))

end