

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("timeit.jl")


# Lecture des noms des instances
working_directory = pwd()
cd("..\\..\\instances\\stsp\\")
filenames = readdir()
cd(working_directory)  # retour au working directory

dims = [] # Dimensions des instances
times = [] # Temps d'exécution

#filenames = ["gr17.tsp", "gr21.tsp", "gr24.tsp", "gr48.tsp"]

for FileName in filenames

  # Sauvegarde du chemin du fichier contenant le data
  cd("..\\..\\instances\\stsp\\")
  data_dir = joinpath(pwd(), FileName)  # NOTE : devrait fonctionner avec Windows et Unix, cependant Unix pas testé!!! 
  cd(working_directory)  # retour au working directory

  # Nom et dimension
  headers_ = read_header(data_dir)
  GraphName = headers_["NAME"]
  dim = parse(Int, headers_["DIMENSION"])

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

plot(dims, times)
xlabel!("Dimension")
ylabel!("Temps moyen d'exécution")
savefig("execution_time.png")