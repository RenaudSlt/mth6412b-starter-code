include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("prim_algorithm.jl")
include("timeit.jl")


# Lecture des noms des instances
working_directory = pwd()
cd(joinpath(working_directory, "instances", "stsp"))
filenames = readdir()
cd(working_directory)  # retour au working directory

filter!(e -> e ≠ "pa561.tsp", filenames) # Retrait de l'instance pa561.tsp qui est trop grande

dims = [] # Dimensions des instances
times_kruskal = [] # Temps d'exécution Kruskal
times_prim = [] # Temps d'exécution Prim


for FileName in filenames

  # Sauvegarde du chemin du fichier contenant le data
  cd(joinpath(working_directory, "instances", "stsp"))
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
    add_node!(G, Node{Nothing}(nothing, string(i)))
  end

  # Ajout des arêtes
  edges, weights = read_edges(headers_, data_dir) 
  for j in 1:length(edges)
    node1 = Node{Nothing}(nothing, string(edges[j][1]))
    node2 = Node{Nothing}(nothing, string(edges[j][2]))
    add_edge!(G, Edge{Nothing}(node1, node2, weights[j]))
  end

  # Algorithmes
  push!(times_kruskal, timeit(kruskal_algorithm, G; nruns=10))
  push!(times_prim, timeit(prim_algorithm, G, get_nodes(G)[1]; nruns=10))
end


# Plot
#plot(dims, times_kruskal, seriestype = :scatter, label = "Kruskal", color = :blue, legend=:topleft)
#plot(dims, times_prim, seriestype = :scatter, label = "Prim", color = :red, legend=:topleft)
plot(dims, [times_kruskal, times_prim], seriestype = :scatter,  label = ["Kruskal" "Prim"], legend=:topleft) #log10.(times)
xlabel!("dimension")
ylabel!("temps moyen d'exécution")
savefig("execution_time_kruskal_prim.png")
