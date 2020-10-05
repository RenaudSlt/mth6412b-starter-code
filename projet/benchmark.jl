

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("timeit.jl")


# Lecture des noms des instances
working_directory = pwd()
cd("..\\instances\\stsp\\")
filenames = readdir()
cd(working_directory)  # retour au working directory

filter!(e -> e ≠ "pa561.tsp", filenames) # Retrait de l'instance pa561.tsp qui est trop grande

dims = [] # Dimensions des instances
times = [] # Temps d'exécution

for FileName in filenames

  # Sauvegarde du chemin du fichier contenant le data
  cd("..\\instances\\stsp\\")
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
  local edges_, weights_ = read_edges(headers_, data_dir) 
  for j in 1:length(edges_)
    local node1 = Node{Nothing}(nothing, string(edges_[j][1]))
    local node2 = Node{Nothing}(nothing, string(edges_[j][2]))
    add_edge!(G, Edge{Nothing}(node1, node2, weights_[j]))
  end

  # Algorithme de Kruskal
  push!(times, timeit(kruskal_algorithm, G; nruns=10))
end

# Plot
plot(dims, log10.(times), seriestype = :scatter, legend=:topleft)
xlabel!("Dimension")
ylabel!("Log(temps moyen d'exécution)")
savefig("execution_time_log.png")