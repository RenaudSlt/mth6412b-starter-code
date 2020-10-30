include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("markednode.jl")
include("edge.jl")


""" Algorithme de Prim : supporté par une structure de donnée MarkedNode{T} dans markednode.jl 
    -Fonctionnement :
      1) arêtes légères sont choisis itérativement à partir d'un noeud source s::Node{T}
      2) l'arête légère doit associer un noeud n1, appartenant au sous-arbre de recouvrement, à un autre n2 qui n'appartient pas encore au sous-arbre de recouvrement  
  Note : une arête légère est celle ayant le plus petit min_weight, qui une distance entre un n2 et le n1 le plus proche, où n appartient au sous-arbre 

    Input : 1) Graph connexe ayant des sommets et des arcs 2) un noeud source
    Output : 1) Ensemble d'arêtes formant le recouvrement minimal 2) poids de l'arbre recouvrant minimal
"""
function prim_algorithm(graph::Graph{T}, source::Node{T}) where T
    
    ### Initilisation
    
    # Accès aux noeuds du graphe
    nodes_graph = get_nodes(graph)
    
    # Liste contenant les noeuds qui font parti du sous-arbre de recouvrement
    visited_nodes = MarkedNode{T}[]

    # Liste qui va agir de manière équivalente à une priorityQueue avec la fonction popfirst!() de MarkedNode
    marked_nodes_queue = MarkedNode{T}[] 

    # Instacie et affecte les Markednode à la liste marked_nodes_queue : les MarkedNode sont instanciés à partir des Node
    for i = 1:nb_nodes(graph)
        # Ensemble disjoints de MarkedNode, puisque parent=nothing pour tous
        # Le poids de la source est initié à 0
        if nodes_graph[i] == source
          push!(marked_nodes_queue, MarkedNode{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i]), min_weight_=0))
        else
          push!(marked_nodes_queue, MarkedNode{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i])))
        end
    end

    

    ### Algorithme ###
    edges_graph_min = Edge{T}[]
    weight_min = 0
    while  !isempty(marked_nodes_queue)
    
      # On retire le noeud ayant le plus petit weight et on l'ajoute aux noeuds appartenant au sous-arbre (visited_nodes)
      u = popfirst!(marked_nodes_queue)
      push!(visited_nodes, u)
      set_visited!(u)
      
      #idx = findfirst(x -> x == u, get_nodes(graph))
      #u_node = get_nodes(graph)[idx]
      
      #sub_edges = get_edges_from_node(graph, u_node)  
      sub_edges = get_edges_from_node(graph, u)
      edge_to_add = sub_edges[1]

      # Relaxation
      for edge in sub_edges
        
        # On détermine le noeud associé à l'arête (u,v) ou (v,u) : on traite le cas [...]
        #v_node = (u_node == get_node1(edge)) ?  get_node2(edge) :  get_node1(edge)
        v_node = (u == get_node1(edge)) ?  get_node2(edge) :  get_node1(edge)

        # Retrouver le MarkedNode correspondant à v 
        idx = findfirst(x -> x == v_node, marked_nodes_queue) 
        if idx === nothing
          idx = findfirst(x -> x == v_node, visited_nodes)
          v = visited_nodes[idx]
        else
          v = marked_nodes_queue[idx]
        end
        

        # On détermine l'arête légère
        if  v == get_parent(u)
          edge_to_add = edge
        end

        is_visited(v) && continue 
        
        # Test de relaxation 
        if get_weight(edge) < get_min_weight(v)
          set_min_weight!(v, get_weight(edge)) 
          set_parent!(v,u)
        end

      end

      # Ajout de l'arête légère (sauf lorsque noeud source)
      if u != source
        push!(edges_graph_min, edge_to_add) 
        weight_min += get_weight(edge_to_add) 
      end

    end

    # Ensemble d'arêtes qui forme le recouvrement minimal
    return edges_graph_min, weight_min
end