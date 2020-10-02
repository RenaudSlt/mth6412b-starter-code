include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")

### Se placer dans le répertoire 'mth6412b-starter-code/projet/phase1' ###

# Choix de l'instance
#FileName = "bayg29.tsp"   # upper row
FileName = "gr17.tsp"     # lower diag row
#FileName = "swiss42.tsp"  # full matrix

# Sauvegarde du chemin du fichier contenant le data
working_directory = pwd()
cd("..\\..\\instances\\stsp\\")
data_dir = joinpath(pwd(), FileName)  # NOTE : devrait fonctionner avec Windows et Unix, cependant Unix pas testé!!! 
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
  add_node!(G, Node{Nothing}(nothing, string(i)))
end

# Ajout des arêtes
edges_, weights_ = read_edges(headers_, data_dir) 
for j in 1:length(edges_)
  local_node1 = Node{Nothing}(nothing, string(edges_[j][1]))
  local_node2 = Node{Nothing}(nothing, string(edges_[j][2]))
  add_edge!(G, Edge{Nothing}(local_node1, local_node2, weights_[j]))
end

# Affichage du graphe
show(G)

# Algorithme de Kruskal
#kruskal_algorithm(G)
