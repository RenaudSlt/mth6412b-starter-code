include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal_algorithm.jl")
include("rsl_algorithm.jl")

### Se placer dans le répertoire 'mth6412b-starter-code' ###

# Instances sur lesquelles la propriété de RSL n'est pas vérifiée
FileName = "bays29.tsp"
#FileName = "brg180.tsp"
#FileName = "swiss42.tsp"

# Sauvegarde du chemin du fichier contenant le data
working_directory = pwd()

cd(joinpath(working_directory, "instances", "stsp"))
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


# Détection des triplets de noeuds u,v,w tels que c(u,w) > c(u,v) + c(v,w)
for i in 1:nb_nodes(G)
  for j in (i+1):nb_nodes(G)
    global node_u
    global node_v
    global edges
    node_u = get_nodes(G)[i]
    node_w = get_nodes(G)[j]
    edges = get_edges(G)

    # Recherche de l'arête (u,v)
    for edge in edges
      global edge_uw
      if (get_node1(edge) == node_u && get_node2(edge) == node_w) || (get_node1(edge) == node_w && get_node2(edge) == node_u)
        edge_uw = edge
        continue
      end
    end

    # Recherche des noeuds v tels que c(u,w) > c(u,v) + c(v,w)
    for node in get_nodes(G)
      global edge_uv
      global edge_vw
      (node == node_u && node == node_w) && continue
      for edge in edges
        if (get_node1(edge) == node_u && get_node2(edge) == node) || (get_node1(edge) == node && get_node2(edge) == node_u)
          edge_uv = edge
        end
        if (get_node1(edge) == node && get_node2(edge) == node_w) || (get_node1(edge) == node_w && get_node2(edge) == node)
          edge_vw = edge
        end
      end

      # Affichage quand la condition n'est pas vérifiées
      if get_weight(edge_uw) > get_weight(edge_uv) + get_weight(edge_vw)
        println("Not ok at u = ", get_name(node_u), ", w = ", get_name(node_w), " and v = ", get_name(node))
        println(get_weight(edge_uw), " > ", get_weight(edge_uv), " + ", get_weight(edge_vw))
      end
    end

  end
end