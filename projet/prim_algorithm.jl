include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("markednode.jl")
include("edge.jl")


function prim_algorithm(graph::Graph{T}, s::Node{T}) where T
    
    ### Initialisation ###

    # Accès aux noeuds du graphe
    nodes_graph = get_nodes(graph)
    
    visited_nodes = MarkedNode{T}[]

    # Genere un vecteur de MarkedNode à partir des noeuds du Graph : les MarkedNode sont instanciés à partir des Node
    marked_nodes_queue = MarkedNode{T}[] 
    for i = 1:nb_nodes(graph)
        # Ensemble disjoints de MarkedNode, puisque parent=nothing pour tous
        # Le poids de la source est initié à 0
        if nodes_graph[i] == s
          push!(marked_nodes_queue, MarkedNode{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i]), min_weight_=0))
        else
          push!(marked_nodes_queue, MarkedNode{T}(get_data(nodes_graph[i]), name_=get_name(nodes_graph[i])))
        end
    end

    
    ### Algorithme ###
    edges_graph_min = Edge{T}[]
    weight_min = 0

    while  !isempty(marked_nodes_queue)
    
      u = popfirst!(marked_nodes_queue)
      push!(visited_nodes, u)
      set_visited!(u)
      
      # Détermine
      idx = findfirst(x -> x == u, get_nodes(graph))
      u_node = get_nodes(graph)[idx]
      
      sub_edges = get_edges_from_node(graph, u_node)  
      edge_to_add = sub_edges[1]

      # Relaxation
      for edge in sub_edges
        
        # On détermine le noeud associé à l'arête (u,v) ou (v,u) : on traite le cas [...]
        v_node = (u_node == get_node1(edge)) ?  get_node2(edge) :  get_node1(edge)
        #println(v_node)

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

      #println(edge_to_add)

      # Ajout de l'arête légère (sauf lorsque noeud source)
      if u != s
        push!(edges_graph_min, edge_to_add) 
        weight_min += get_weight(edge_to_add) 
      end

    end

    # Ensemble d'arêtes qui forme le recouvrement minimal
    return edges_graph_min, weight_min
end