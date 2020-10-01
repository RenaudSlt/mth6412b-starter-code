include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

### Se placer dans le répertoire 'mth6412b-starter-code/projet/phase1' ###

# Choix de l'instance
#FileName = "bayg29.tsp"   # upper row
FileName = "gr17.tsp"     # lower diag row
#FileName = "swiss42.tsp"  # full matrix

# Sauvegarde du chemin du fichier contenant le data
if Sys.iswindows()
  working_directory = pwd()
  cd("..\\..\\instances\\stsp\\")
  data_dir = string(pwd(), "\\" , FileName)
  cd(working_directory)  # retour au working directory
else # Unix system
  working_directory = pwd()
  cd("../../instances/stsp/")
  data_dir = string(pwd(), "/" , FileName)
  cd(working_directory)
end

# Nom et dimension
headers_ = read_header(data_dir)
GraphName = headers_["NAME"]
dim = parse(Int, headers_["DIMENSION"])

# Création du graphe vide
#G = Graph(GraphName, Array{Node{Nothing}}(undef,0), Array{Edge{Nothing}}(undef,0))  
G = Graph{Nothing}()
set_name!(G, GraphName)


# Ajout des noeuds (le champ data est égal à nothing)
for i in 1:dim
  node = Node(string(i), nothing)
  add_node!(G, node)
end

# Ajout des arêtes
edges_, weights_ = read_edges(headers_, data_dir) 
for j in 1:length(edges_)
  local_node1 = Node(string(edges_[j][1]), nothing)
  local_node2 = Node(string(edges_[j][2]), nothing)
  local_edge = Edge(local_node1, local_node2, weights_[j])
  add_edge!(G, local_edge)
end

# Affichage du graphe
show(G)