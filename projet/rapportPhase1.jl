### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ baca00b0-ff3d-11ea-2f17-9fdd02ade29a
md"# MTH6412B - Rapport de la phase 1 "

# ╔═╡ b9164b50-ff3f-11ea-15c9-09c92b9d700f
md" Edward Hallé-Hannan\
Renaud Saltet"

# ╔═╡ db5b8360-ff6c-11ea-1217-496a57b3330f
md" Lien vers le dépôt de la phase 1 : [https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase1](https://github.com/RenaudSlt/mth6412b-starter-code/tree/phase1)"

# ╔═╡ 31a25150-ff71-11ea-2f1a-c96935fd9a20
md" ***"

# ╔═╡ a157de80-ff48-11ea-33e7-6710b4fb5416
md"### Structure d'arête "

# ╔═╡ f98a9030-ff47-11ea-2a99-85269f4e5595
md" Dans notre projet, un objet `edge` contient trois champs :\

* un premier noeud de type T
* un deuxième noeud de type T
* un poids de type Number 

Le type `edge` est implémenté dans le fichier `edge.jl`."

# ╔═╡ 6de424fe-ff56-11ea-1d15-9f2ef8ce89dd
md"
"""
abstract type AbstractEdge{T} end
	
mutable struct Edge{T} <: AbstractEdge{T}
	node1::Node{T}
	node2::Node{T}
	weight::Number
end

# ╔═╡ a1f036d0-ff5c-11ea-29a8-f79234ff41ef
md" Le type du champ `weight` est gardé le plus abstrait possible de façon à pouvoir utiliser des poids entiers ou flottants."

# ╔═╡ 01b71ac0-ff5d-11ea-21d2-cfce9ca9079f
md" Comme pour un objet `node`, des fonctions permettent d'accéder aux champs d'un objet `edge`. Une fonction `show` permet d'afficher une arête."

# ╔═╡ 2b42a210-ff5d-11ea-0d17-d90f7498b751
md"
"""
"""Renvoie le noeud 1."""
Node1(edge::AbstractEdge) = edge.node1

"""Renvoie le noeud 2."""
Node2(edge::AbstractEdge) = edge.node2

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche un noeud."""
function show(edge::AbstractEdge)
  println("Edge of weigth ", weight(edge), " between the nodes \"", name(Node1(edge)), "\" and \"", name(Node2(edge)), "\".")
end

# ╔═╡ db326370-ff5f-11ea-2636-1d6774fde369
md" Ainsi, les instructions suivantes créent et affichent une arête : "

# ╔═╡ ec87f310-ff5f-11ea-264b-a7740dce4373
md"
"""
node1 = Node("Joe", 3.14)
node2 = Node("Steve", exp(1))
edge0 = Edge(node1, node2, 3.2)
show(edge0)


# ╔═╡ 67f133c0-ff62-11ea-26db-8b8c6e88960b
md" `>>> Edge of weigth 3.2 between the nodes \"Joe\" and \"Steve\".`"

# ╔═╡ 9ef502be-ff5d-11ea-2cdf-11f25c835c5c
md" *** "

# ╔═╡ 92feb96e-ff5d-11ea-2e03-f96b885b2143
md"### Intégration dans un graphe"

# ╔═╡ 92bcf57e-ff5d-11ea-3e2c-1fb4b6d0f84e
md" Nous avons ajouté un champ `edges` au type `Graph` dans le fichier `graph.jl`. Ce champ est un vecteur d'arêtes. Cela permet d'ajouter simplement une arête à un graphe. "

# ╔═╡ 92a1a550-ff5d-11ea-1aa5-2b41185f82d1
md"
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T}}
end

# ╔═╡ 9bdd1030-ff64-11ea-22d5-e3986346011a
md" La fonction `add_nodes!` est inchangée. Nous avons ajouté la fonction `add_edges!` qui permet d'ajouter une arête à un graphe existant en s'assurant que cette arête reliet bien deux sommets appartenant au graphe."

# ╔═╡ c922b950-ff64-11ea-1f4f-0323233a1ed7
md" Par souci de lisibilité, nous avons créé une fonction auxiliaire `node_in_nodes` qui renvoie **true** si le nœud `node` se trouve dans le vecteur de nœuds `nodes`, et **false** sinon. Nous avions pensé utiliser simplement un test `node in nodes` mais cela ne fonctionne puisque deux nœuds différents ayant les mêmes champs ne sont pas perçus égaux pas le programme. Nous avons donc comparé directement les champs. "

# ╔═╡ d8b75f10-ff64-11ea-25c7-077f344966c5
md"
"""
function node_in_nodes(node::Node{T}, nodes::Vector{Node{T}}) where T
  for i in 1:length(nodes)
    if name(node) == name(nodes[i]) && data(node) == data(nodes[i])
      return true
    end
  end
  return false
end

# ╔═╡ 602e3710-ff66-11ea-3598-29ef85f16383
md" Ensuite la fonction `add_edges!` ajoute le nœuds en argument au vecteur des nœuds du graphe en argument.

Nous avons choisi de *ne pas* tester si un nœud était redondant avec un nœud déjà dans le graphe car cette procédure est couteuse et cela devenait sensible sur les plus grandes instances."

# ╔═╡ 7e2eba00-ff66-11ea-1c3c-6d9fa56f4b21
md"
"""
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  if !(node_in_nodes(Node1(edge), nodes(graph))) || !(node_in_nodes(Node2(edge), nodes(graph)))
    @error("Impossible to add edge.\nAt least one of the following nodes is not in the graph :", Node1(edge), Node2(edge))
  else
    push!(graph.edges, edge)
    graph
  end
end

# ╔═╡ ae3f910e-ff66-11ea-2f9e-dd59e8189e87
md" Nous avons également ajouté des fonctions permettant d'accéder aux arêtes et à leur nombre. "

# ╔═╡ da6d6190-ff66-11ea-3eb8-157ab2c80c2a
md"
"""
"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

# ╔═╡ e6f20832-ff66-11ea-0c92-57e0bcc9b5f4
md" Enfin, la fonction `show` a été modifiée afin d'afficher les arêtes. "

# ╔═╡ 076b5350-ff67-11ea-0984-51911e8af62e
md"
"""
"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("\nNodes :")
  for node in nodes(graph)
    show(node)
  end
  println("\nEdges :")
  for edge in edges(graph)
    show(edge)
  end
end

# ╔═╡ 2da42d30-ff67-11ea-3603-35c06f658844
md" Ainsi, les instructions suivantes créent et affichent un graphe : "

# ╔═╡ 49037860-ff67-11ea-23c4-8d341b1c423b
md"
"""
node1 = Node("Joe", 3.14)
node2 = Node("Steve", exp(1))
node3 = Node("Jill", 4.12)

edge1 = Edge(node1, node2, 1)
edge2 = Edge(node2, node3, -2)

G = Graph("Ick", [node1, node2, node3], [edge1, edge2])

show(G)

# ╔═╡ 97bbc0c0-ff67-11ea-0a10-fb899322758d
md" `>>> Graph Ick has 3 nodes and 2 edges.`\
`>>> `\
`>>> Nodes :`\
`>>> Node Joe, data: 3.14`\
`>>> Node Steve, data: 2.718281828459045`\
`>>> Node Jill, data: 4.12`\
`>>> `\
`>>> Edges :`\
`>>> Edge of weigth 1 between the nodes \"Joe\" and \"Steve\".`\
`>>> Edge of weigth -2 between the nodes \"Steve\" and \"Jill\".` 
"

# ╔═╡ 2b804980-ff6c-11ea-32f4-db1727f7433d
md" *** "

# ╔═╡ 9af42f70-ff67-11ea-3639-5705a7ef446b
md" ### Lecture des instances"

# ╔═╡ 41732f00-ff6c-11ea-19dc-2187eb97b57d
md" La fonction `read_edges` du fichier `read_stsp.jl` a été modifiée afin de lire les poids des arêtes dans un fichier `.tsp`.

Cette fonction retourne désormais un vecteurs des poids des arêtes en plus du vecteur des arêtes.

Les lignes ajoutées sont suivies d'un commentaire dans la cellule suivante." 

# ╔═╡ 4131b930-ff6c-11ea-33e4-4962e52e025d
md"
"""
"""Analyse un fichier .tsp et renvoie l'ensemble des arêtes sous la forme d'un tableau."""
function read_edges(header::Dict{String}{String}, filename::String)

  edges = []
  weights = [] # liste des poids des arêtes
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]
  known_edge_weight_formats = ["FULL_MATRIX", "UPPER_ROW", "LOWER_ROW",
  "UPPER_DIAG_ROW", "LOWER_DIAG_ROW", "UPPER_COL", "LOWER_COL",
  "UPPER_DIAG_COL", "LOWER_DIAG_COL"]

  if !(edge_weight_format in known_edge_weight_formats)
    @warn "unknown edge weight format" edge_weight_format
    return edges
  end

  file = open(filename, "r")
  dim = parse(Int, header["DIMENSION"])
  edge_weight_section = false
  k = 0
  n_edges = 0
  i = 0
  n_to_read = n_nodes_to_read(edge_weight_format, k, dim)
  flag = false

  for line in eachline(file)
    line = strip(line)
    if !flag
      if occursin(r"^EDGE_WEIGHT_SECTION", line)
        edge_weight_section = true
        continue
      end

      if edge_weight_section
        data = split(line)
        n_data = length(data)
        start = 0
        while n_data > 0
          n_on_this_line = min(n_to_read, n_data)
          for j = start : start + n_on_this_line - 1
            weight = parse(Int64, data[j+1]) # lecture du poids de l'arête courrante
            n_edges = n_edges + 1
            if edge_weight_format in ["UPPER_ROW", "LOWER_COL"]
              edge = (k+1, i+k+2)
            elseif edge_weight_format in ["UPPER_DIAG_ROW", "LOWER_DIAG_COL"]
              edge = (k+1, i+k+1)
            elseif edge_weight_format in ["UPPER_COL", "LOWER_ROW"]
              edge = (i+k+2, k+1)
            elseif edge_weight_format in ["UPPER_DIAG_COL", "LOWER_DIAG_ROW"]
              edge = (i+1, k+1)
            elseif edge_weight_format == "FULL_MATRIX"
              edge = (k+1, i+1)
            else
              warn("Unknown format - function read_edges")
            end
            push!(edges, edge)
            push!(weights, weight) # ajout du poids dans la liste
            i += 1
          end

          n_to_read -= n_on_this_line
          n_data -= n_on_this_line

          if n_to_read <= 0
            start += n_on_this_line
            k += 1
            i = 0
            n_to_read = n_nodes_to_read(edge_weight_format, k, dim)
          end

          if k >= dim
            n_data = 0
            flag = true
          end
        end
      end
    end
  end
  close(file)
  return edges, weights
end

# ╔═╡ c75eac10-ff6d-11ea-1f8d-ff7288cbfd53
md" En conséquence, la fonction `read_stsp` a été modifiée. 

La ligne "

# ╔═╡ f10adac0-ff6d-11ea-27a5-8b0813a4ff35
md"
"""
edges_brut = read_edges(header, filename)

# ╔═╡ f72dbf30-ff6d-11ea-14c6-891937f6d156
md" a été remplacée par la ligne "

# ╔═╡ ff0ece62-ff6d-11ea-0623-1997d9b7b397
md"
"""
edges_brut = read_edges(header, filename)[1]

# ╔═╡ 17a360d0-ff6e-11ea-3361-0d1bc5d3369d
md" Les instructions suivantes lisent les données de l'instance `gr17.tsp`."

# ╔═╡ 84ca3032-ff6e-11ea-1f8f-3f901252398b
md"
"""
headers_ = read_header("./instances/stsp/gr17.tsp")
edges_, weights_ = read_edges(headers_, "./instances/stsp/gr17.tsp")

# ╔═╡ d0b72e20-ff6f-11ea-2dcc-fbd0694dca22
md" edges_"

# ╔═╡ 56d87320-ff6f-11ea-2f54-3d289083ba43
md" `>>> 153-element Array{Any,1}:`\
`>>> (1, 1)`\
`>>> (1, 2)`\
`>>> (2, 2)`\
`>>> (1, 3)`\
`>>> (2, 3)`\
`>>> ⋮`\
`>>> (13, 17)`\
`>>> (14, 17)`\
`>>> (15, 17)`\
`>>> (16, 17)`\
`>>> (17, 17)`"

# ╔═╡ dafbcfd0-ff6f-11ea-1087-b1a41580bce8
md" weights_"

# ╔═╡ ab79cb3e-ff6f-11ea-19b6-0b6ce65ea765
md" `>>> 153-element Array{Any,1}:`\
`>>> 0`\
`>>> 633`\
`>>> 0`\
`>>> 257`\
`>>> 390`\
`>>> ⋮`\
`>>> 55`\
`>>> 96`\
`>>> 153`\
`>>> 336`\
`>>> 0`"

# ╔═╡ 03fd8db0-ff70-11ea-2e33-151dc79ab892
md" ***"

# ╔═╡ fad92910-ff6f-11ea-31b1-adcb47362bbb
md" ### Programme principal "

# ╔═╡ 0bb87740-ff70-11ea-2e9f-f9c800a60e8b
md" Les instruction suivantes se trouvent dans le fichier `main.jl`. Elles permettent de lire une instance du dossier `instances` et de construire le graphe correspondant.

Suivant le format des poids (EDGE\_WEIGHT\_FORMAT), certaines arêtes pourront être redondante.

Dans la version ci-dessous, c'est encore l'instance `gr17.tsp` qui est lue, transformée en graphe et affichée."

# ╔═╡ 55bd97d0-ff70-11ea-101d-c5b0d95c83ac
md"
"""
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

### Se placer dans le répertoire 'mth6412b-starter-code'

# Choix de l'instance
#FileName = "bayg29.tsp"   # upper row
FileName = "gr17.tsp"     # lower diag row
#FileName = "swiss42.tsp"  # full matrix

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

# ╔═╡ 4cf05e70-ff71-11ea-39a8-adbccd80288e
md" Le résultat de ce programme étant assez long, nous ne l'avons pas mis dans le rapport."

# ╔═╡ Cell order:
# ╟─baca00b0-ff3d-11ea-2f17-9fdd02ade29a
# ╟─b9164b50-ff3f-11ea-15c9-09c92b9d700f
# ╟─db5b8360-ff6c-11ea-1217-496a57b3330f
# ╟─31a25150-ff71-11ea-2f1a-c96935fd9a20
# ╠═a157de80-ff48-11ea-33e7-6710b4fb5416
# ╠═f98a9030-ff47-11ea-2a99-85269f4e5595
# ╠═6de424fe-ff56-11ea-1d15-9f2ef8ce89dd
# ╟─a1f036d0-ff5c-11ea-29a8-f79234ff41ef
# ╟─01b71ac0-ff5d-11ea-21d2-cfce9ca9079f
# ╠═2b42a210-ff5d-11ea-0d17-d90f7498b751
# ╟─db326370-ff5f-11ea-2636-1d6774fde369
# ╠═ec87f310-ff5f-11ea-264b-a7740dce4373
# ╟─67f133c0-ff62-11ea-26db-8b8c6e88960b
# ╠═9ef502be-ff5d-11ea-2cdf-11f25c835c5c
# ╟─92feb96e-ff5d-11ea-2e03-f96b885b2143
# ╟─92bcf57e-ff5d-11ea-3e2c-1fb4b6d0f84e
# ╠═92a1a550-ff5d-11ea-1aa5-2b41185f82d1
# ╟─9bdd1030-ff64-11ea-22d5-e3986346011a
# ╟─c922b950-ff64-11ea-1f4f-0323233a1ed7
# ╠═d8b75f10-ff64-11ea-25c7-077f344966c5
# ╟─602e3710-ff66-11ea-3598-29ef85f16383
# ╠═7e2eba00-ff66-11ea-1c3c-6d9fa56f4b21
# ╟─ae3f910e-ff66-11ea-2f9e-dd59e8189e87
# ╠═da6d6190-ff66-11ea-3eb8-157ab2c80c2a
# ╟─e6f20832-ff66-11ea-0c92-57e0bcc9b5f4
# ╠═076b5350-ff67-11ea-0984-51911e8af62e
# ╟─2da42d30-ff67-11ea-3603-35c06f658844
# ╠═49037860-ff67-11ea-23c4-8d341b1c423b
# ╟─97bbc0c0-ff67-11ea-0a10-fb899322758d
# ╟─2b804980-ff6c-11ea-32f4-db1727f7433d
# ╟─9af42f70-ff67-11ea-3639-5705a7ef446b
# ╟─41732f00-ff6c-11ea-19dc-2187eb97b57d
# ╠═4131b930-ff6c-11ea-33e4-4962e52e025d
# ╟─c75eac10-ff6d-11ea-1f8d-ff7288cbfd53
# ╠═f10adac0-ff6d-11ea-27a5-8b0813a4ff35
# ╟─f72dbf30-ff6d-11ea-14c6-891937f6d156
# ╠═ff0ece62-ff6d-11ea-0623-1997d9b7b397
# ╟─17a360d0-ff6e-11ea-3361-0d1bc5d3369d
# ╠═84ca3032-ff6e-11ea-1f8f-3f901252398b
# ╟─d0b72e20-ff6f-11ea-2dcc-fbd0694dca22
# ╟─56d87320-ff6f-11ea-2f54-3d289083ba43
# ╟─dafbcfd0-ff6f-11ea-1087-b1a41580bce8
# ╟─ab79cb3e-ff6f-11ea-19b6-0b6ce65ea765
# ╟─03fd8db0-ff70-11ea-2e33-151dc79ab892
# ╟─fad92910-ff6f-11ea-31b1-adcb47362bbb
# ╟─0bb87740-ff70-11ea-2e9f-f9c800a60e8b
# ╠═55bd97d0-ff70-11ea-101d-c5b0d95c83ac
# ╟─4cf05e70-ff71-11ea-39a8-adbccd80288e
