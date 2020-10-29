include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("markednode.jl")
include("edge.jl")


function prim_algorithm(graph::Graph{T}, s::String) where T
    
    ### Initialisation ###

    # Accès aux noeuds du graphe
    nodes_graph = get_nodes(graph)
    
    # Genere un vecteur de MarkedNode à partir des noeuds du Graph : les MarkedNode sont instanciés à partir des Node
    marked_nodes_queue = MarkedNode{T}[] 
    for i = 1:nb_nodes(graph)
        # Ensemble disjoints de MarkedNode, puisque parent=nothing pour tous
        # Le poids de la source est initié à 0
        if get_name(nodes_graph[i]) == s
          push!(marked_nodes_queue, MarkedNode{T}(get_data(nodes_graph[i]), name=get_name(nodes_graph[i]), min_weight=0))
        else
          push!(marked_nodes_queue, MarkedNode{T}(get_data(nodes_graph[i]), name=get_name(nodes_graph[i])))
        end
    end

    ### Algorithme ###

    edges_graph_min = Edge{T}[]
    weight_min = 0

    while not empty(marked_nodes_queue)
      u = popfirst!(marked_nodes_queue)
      set_visited!(u)

      for v in neighbors(graph, u) # todo neighbors()
        get_visited(v) && continue
        if get_weight(edge(u,v)) < get_min_weight(v)
          set_min_weight!(v, get_weight(edge(u,v))) # todo edge
          set_parent!(v,u)
        end
      end

      push!(edges_graph_min, edge(u, get_parent(u))) # todo edge
      weight_min += get_weight(edge(u, get_parent(u)) # todo edge
    end

    # Ensemble d'arêtes qui forme le recouvrement minimal
    return edges_graph_min, weight
end