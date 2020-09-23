include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

### Se placer dans le répertoire 'mth6412b-starter-code'

# Choix de l'instance
FileName = "dantzig42.tsp"

# Nom et dimension
headers_ = read_header(string("./instances/stsp/", FileName))
GraphName = headers_["NAME"]
dim = parse(Int, headers_["DIMENSION"])

# Création du graphe vide
G = Graph(GraphName, Array{Node{Nothing}}(undef,0), Array{Edge{Nothing}}(undef,0))

# Ajout des noeuds (le champ data est égal à nothing)
for i in 1:dim
  node = Node(string(i), nothing)
  add_node!(G, node)
end

# Ajout des arêtes
edges_, weights_ = read_edges(headers_, string("./instances/stsp/", FileName))
for j in 1:length(edges_)
  local_node1 = Node(string(edges_[j][1]), nothing)
  local_node2 = Node(string(edges_[j][2]), nothing)
  local_edge = Edge(local_node1, local_node2, weights_[j])
  add_edge!(G, local_edge)
end

# Affichage du graphe
show(G)