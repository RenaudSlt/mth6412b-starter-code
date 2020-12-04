include("read_stsp.jl")
include("node.jl")
include("edge.jl")
include("graph.jl")
include("markednode.jl")
include("nodetree.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("rsl_algorithm.jl")
include(joinpath("..","shredder-julia","bin","tools.jl"))

### Se placer dans le répertoire 'mth6412b-starter-code ###

# Sauvegardes des chemin du fichier contenant le data
working_directory = pwd()
cd(joinpath(working_directory, "shredder-julia", "tsp", "instances"))
filenames = readdir()
filter!(x -> x != ".gitignore", filenames) # retrait du .gitignore
data_directories = [joinpath(pwd(), file) for file in filenames]
cd(working_directory) # retour au working directory

# Noms et dimensions
headers_ = [read_header(data_dir) for data_dir in data_directories ]
graph_names = [head_["NAME"] for head_ in headers_ ]
graph_dimensions = [parse(Int, head_["DIMENSION"]) for head_ in headers_ ]

# Liste de graph
graphs = [Graph{Int}() for i in 1:length(filenames)]
for i = 1:length(graphs)
    set_name!(graphs[i], graph_names[i])
end

# Ajout des noeuds
for i = 1:length(graphs)
  for j in 0:(graph_dimensions[i]-1)
   add_node!(graphs[i], Node{Int}(j, name_=string(j), index_=j))
  end
end

# Ajout des arêtes
for i = 1:length(graphs)
  local edges, weights = read_edges(headers_[i], data_directories[i]) 
  for j in 1:length(edges)
    node1_name = string(edges[j][1]-1)
    node2_name = string(edges[j][2]-1)
    idx1 = findfirst(x -> get_name(x)==node1_name, get_nodes(graphs[i]))
    idx2 = findfirst(x -> get_name(x)==node2_name, get_nodes(graphs[i]))
    temp_edge = Edge{Int}(get_nodes(graphs[i])[idx1], get_nodes(graphs[i])[idx2], (Int(weights[j])==0) ? 10^6 : weights[j])
    # On évite les boucles
    if (get_nodes(graphs[i])[idx1] != get_nodes(graphs[i])[idx2])
      add_edge!(graphs[i], temp_edge)
    end 
  end
end


# Paramètres des meilleures tournées trouvées
best_parameters_rsl_prim = Dict("abstract-light-painting"=>["prim",510,12393175],"alaska-railroad"=>["prim",100,7822262],"blue-hour-paris"=>["prim",200,4063554],"lower-kananaskis-lake"=>["prim",480,4300317],"marlet2-radio-board"=>["prim",110,9129699],"nikos-cat"=>["prim",20,3127465],"pizza-food-wallpaper"=>["prim",410,5136087],"the-enchanted-garden"=>["prim",30,20010832],"tokyo-skytree-aerial"=>["prim",20,13654601],)
best_parameters_rsl_kruskal = Dict("abstract-light-painting"=>["kruskal",400,12359023],"alaska-railroad"=>["kruskal",7779637,600],"blue-hour-paris"=>["kruskal",200,3989701],"lower-kananaskis-lake"=>["kruskal",200,4254147],"marlet2-radio-board"=>["kruskal",200,8997767],"nikos-cat"=>["kruskal",200,3077214],"pizza-food-wallpaper"=>["kruskal",400,5100665],"the-enchanted-garden"=>["kruskal",600,19976343],"tokyo-skytree-aerial"=>["kruskal",0,Inf],)

function main_rsl_prim(instance)
  # Prim seulement
  println("\nPRIM\n")
  for i in [1,2,3,4,5,6,7,8,9]
    if i != instance
      continue
    end
    
    println("\n", chop(filenames[i], tail=4))
    min = Inf # meilleure tournée à date
    for algo in ["prim"]

      for j in 1:nb_nodes(graphs[i])
        # On essaie un noeud sur N
        if j%10 != 0
          continue
        end

        println("noeud ", j)
        route_nodes, route_edges, route_weight = rsl_algorithm(graphs[i], algo, get_nodes(graphs[i])[j])
        # Si amélioration, on mémorise le noeud racine, et le poids 
        # et on sauvegarde le tour et l'image
        if route_weight-2*10^6 < min
          
          # Sauvegarde des Paramètres
          min = route_weight-2*10^6
          best_parameters_rsl_prim[chop(filenames[i], tail=4)][2] = get_index(get_nodes(graphs[i])[j])
          best_parameters_rsl_prim[chop(filenames[i], tail=4)][3] = route_weight-2*10^6

          #Transformation de la tournée en fichier .tour
          # Transformer route_nodes en array
          tour = Array{Int64}(undef, 1)
          for node in route_nodes
            push!(tour, get_data(node))
          end

          # Suppression de l'outlier
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

          # Suppression de l'outlier
          for i in 1:length(tour)
            if tour[i]>601
              deleteat!(tour, i)
              break
            end
          end
          # Supression d'un éventuel 602-ième élément
          while length(tour) > 601
            println("IN 602  !!")
            pop!(tour)
          end

          # Sauvegarde du tour
          mkpath(joinpath("shredder-julia", "parameters_optimization", chop(filenames[i], tail=4), "prim", "tsp", ))
          tour_filename = joinpath("shredder-julia", "parameters_optimization", chop(filenames[i], tail=4), "prim", "tsp", string(chop(filenames[i], tail=4), "_", route_weight-2*10^6, "_root-is-", j, ".tour"))
          write_tour(tour_filename, tour, Float32(route_weight))
          
          # Reconstruction de l'image
          input_name = joinpath("shredder-julia", "images", "shuffled", string(chop(filenames[i], tail=4),".png"))
          output_name = joinpath("shredder-julia", "parameters_optimization", chop(filenames[i], tail=4), "prim", "images", string(chop(filenames[i], tail=4), "_", route_weight-2*10^6, "_root-is-", j, ".png"))
          reconstruct_picture(tour_filename, input_name, output_name)
        end
      end
    end
  end

end

function main_rsl_kruskal(inf, sup)
  # Kruskal seulement
  println("\nKRUSKAL\n")
  for i in [1,2,3,4,5,6,7,8,9]
    if (i<inf) || (i>sup)
      continue
    end

    println("\n", filenames[i])

    min = Inf # meilleure tournée à date
    for algo in ["kruskal"]
      for j in 1:nb_nodes(graphs[i])
        # On essaie un noeud sur N
        if j%200 != 0
          continue
        end
        println("noeud ", j)

        route_nodes, route_edges, route_weight = rsl_algorithm(graphs[i], algo, get_nodes(graphs[i])[j])
        
        println("rsl kruskal fait")

        # Si amélioration, on mémorise le noeud racine, et le poids 
        # et on sauvegarde le tour et l'image
        if route_weight-2*10^6 < min

          println("amélioration")

          # Sauvegarde des Paramètres
          min = route_weight-2*10^6
          best_parameters_rsl_kruskal[chop(filenames[i], tail=4)][2] = get_index(get_nodes(graphs[i])[j])
          best_parameters_rsl_kruskal[chop(filenames[i], tail=4)][3] = route_weight-2*10^6

          println("sauvegarde ok")

          #Transformation de la tournée en fichier .tour
          # Transformer route_nodes en array
          tour = Array{Int64}(undef, 1)
          for node in route_nodes
            push!(tour, get_data(node))
          end

          println("transformation en tour ok")

          # Suppression de l'outlier
          for i in 1:length(tour)
            if tour[i]>601
              deleteat!(tour, i)
              break
            end
          end

          println("tour : ")
          show(tour)

          println("permutation ...")

          # Permuter circulairement les éléments de tour jusqu'à obtenir le noeud 0 en premier
          while tour[1] != 0
            tour = vcat(tour[2:end], tour[1])
          end

          println("permutation ok")

          # Suppression de l'outlier
          for i in 1:length(tour)
            if tour[i]>601
              deleteat!(tour, i)
              break
            end
          end
          # Supression d'un éventuel 602-ième élément
          while length(tour) > 601
            println("IN 602  !!")
            pop!(tour)
          end

          # Sauvegarde du tour
          mkpath(joinpath("shredder-julia", "parameters_optimization", chop(filenames[i], tail=4), "kruskal", "tsp", ))
          tour_filename = joinpath("shredder-julia", "parameters_optimization", chop(filenames[i], tail=4), "kruskal", "tsp", string(chop(filenames[i], tail=4), "_", route_weight-2*10^6, "_root-is-", j, ".tour"))
          write_tour(tour_filename, tour, Float32(route_weight))

          println("sauvegarde tour ok")
          
          # Reconstruction de l'image
          input_name = joinpath("shredder-julia", "images", "shuffled", string(chop(filenames[i], tail=4),".png"))
          output_name = joinpath("shredder-julia", "parameters_optimization", chop(filenames[i], tail=4), "kruskal", "images", string(chop(filenames[i], tail=4), "_", route_weight-2*10^6, "_root-is-", j, ".png"))
          reconstruct_picture(tour_filename, input_name, output_name)

          println("sauvegarde image ok")

        end
      end
    end
  end

end