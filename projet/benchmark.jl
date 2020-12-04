include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("timeit.jl")


# Lecture des noms des instances
working_directory = pwd()
cd("instances\\stsp\\")
filenames = readdir()
cd(working_directory)  # retour au working directory

filter!(e -> e ≠ "pa561.tsp", filenames) # Retrait de l'instance pa561.tsp qui est trop grande

dims = [] # Dimensions des instances
times = [] # Temps d'exécution

for FileName in filenames

  # Sauvegarde du chemin du fichier contenant le data
  cd("instances\\stsp\\")
  local data_dir = joinpath(pwd(), FileName)  # NOTE : devrait fonctionner avec Windows et Unix, cependant Unix pas testé!!! 
  cd(working_directory)  # retour au working directory

  # Nom et dimension
  local headers_ = read_header(data_dir)
  local GraphName = headers_["NAME"]
  local dim = parse(Int, headers_["DIMENSION"])

  push!(dims, dim)

  # Création du graphe vide
  local G = Graph{Nothing}()
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

  # Algorithme de Kruskal
  #res = timeit(kruskal_algorithm, G; nruns=10)
  
  # Algorithme de Prim
  res = timeit(prim_algorithm, G; nruns=10)

  println(GraphName, " : ", res)
  push!(times, res)
end

println("\ndims : ")
show(dims)
println("\ntimes : ")
show(times)

# Plot
#plot(dims, times, seriestype = :scatter, legend=:topleft)
#xlabel!("Dimension")
#ylabel!("Log(temps moyen d'exécution)")
#savefig("execution_time_log.png")