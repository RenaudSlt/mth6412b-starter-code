include("graph.jl")
include("node.jl")
include("nodeTree.jl")
include("markednode.jl")
include("edge.jl")
include("prim_algorithm.jl")
include("kruskal_algorithm.jl")


""" Algorithme de HK
"""
function hk_algorithm(graph::Graph{T}, algo_MST::String, source::Node{T}=get_nodes(graph)[1], initial_step_size::Float64=1.0, stop_criterion::String="t_step") where T


  if !(algo_MST == "kruskal" || algo_MST == "prim") 
    @error("Invalid input argument for algo_MST argument : ", algo_MST, "\n Possible String inputs are :\n prim \n kruskal")
  end

  if !(stop_criterion == "t_step" || stop_criterion == "period_length" || stop_criterion == "sub_gradient")
    @error("Invalid input argument for stop_criterion argument : ", stop_criterion,  "\n Possible String inputs are :\n t_step \n period_length \n sub_gradient")
  end
 


  # Initialisation
  n = nb_nodes(graph)
  k = 0 
  π = zeros(n)
  best_valid_π = zeros(n)
  v = zeros(n)
  v_prev = zeros(n)
  best_v = zeros(n)
  w = 0
  W = -Inf
  
  # Initialisation pour le pas
  t = initial_step_size
  period_length = fld(n,2)  # partie entière de n/2
  period_counter = 0
  first_period_exception = true
  τ = 2.0

  # Flag pour atteinte d'une tournée
  tour_obtained = false
  
  # Flags pour gérer les critères d'arrêt 
  step_size_min_obtained = false  # Flag : critère arrêt sur le step
  period_size_min_obtained = false  
  sub_gradient_null = false 

  # Flag pour gérer le cas où une tournée n'est pas obtenue, mais qu'on peut en déterminer une
  # en post-processing
  reconstruction_possible = false 
  tour_obtained_with_reconstruction = false

  
  # Initialisation des copies profonds pour ne pas modifier le graph passer en argument
  graph_copy = deepcopy(graph)
  best_one_tree = deepcopy(graph) 
  best_valid_one_tree = deepcopy(graph)

  # Boucle principale
  while (sub_gradient_null==false && step_size_min_obtained==false && period_size_min_obtained==false )

    # Transformation des poids en c_ij + π_i + π_j
    update_weights!(graph_copy, t.*( (0.7 .* v) + (0.3 .* v_prev )))
    π = π + t.*( (0.7 .* v) + (0.3 .* v_prev ))

    # Détermine le noeud special qui est enlevé du graph pour faire le MST et le noeud source pour partir l'algo MST
    #n_source = rand(1:n)
    #source = get_nodes(graph_copy)[n_source]

    # Calcul d'un arbre de recouvrement minimal sur les noeuds {1,2,3,...,n}
    if algo_MST == "kruskal"
      minimal_edges, minimal_weight, minimal_subtree = kruskal_by_prim(graph_copy, source)
    elseif algo_MST == "prim"
      minimal_edges, minimal_weight, minimal_subtree = prim_algorithm(graph_copy, source)
    end

    ### Heuristique article
    
    # Étape 1 : on récolte toute les feuilles de l'arbre de recouvrement 
    root = get_root!(minimal_subtree[1])
    leaves_minimal_tree = MarkedNode{T}[]
    get_leaves!(root, leaves_minimal_tree)

    # Étape 2 on retrouve les nodes correspondant aux feuilles
    leaves_node = deepcopy(get_nodes(graph))
    filter!(x-> x ∈ leaves_minimal_tree, leaves_node)

    # Étape 3 : déterminer les secondes arêtes minimales des feuilles
    second_min_edge = Edge{T}[] 
    for leaf in leaves_node
      edges_leaf = deepcopy(get_edges_from_node(graph_copy, leaf))
      popfirst!(edges_leaf)
      push!(second_min_edge, popfirst!(edges_leaf)) 
    end

    # Étape 4 : déterminer le maximum des secondes arêtes minimales
    max_second_min_edge = second_min_edge[1]
    for edge in second_min_edge
      if get_weight(edge) > get_weight(max_second_min_edge)
        max_second_min_edge = edge
      end
    end

    # On effectue une deepcopy pour éviter les modifications à l'interne des attributs
    push!(minimal_edges, max_second_min_edge) 

    one_tree = Graph("minimal_graph", get_nodes(graph_copy) , minimal_edges) 
    cost_one_tree = minimal_weight + get_weight(max_second_min_edge) 

    # Mise à jour de w_prev, w, W et v
    w_prev = w
    w = cost_one_tree - 2*sum(π)
    W = max(W, w)
    v_prev = v
    v = get_degrees(one_tree) .- 2 

     # Amélioration du one-tree
    if w > w_prev
      best_one_tree = one_tree

      v_valid, number_of_ones = v_score(v)
      # Si tous les degrés en absolu sont plus petit que 1 on sauvegarde ce one-tree 
      # NOTE : possible de déterminer une tournée non-optimale en POST-processing sous cette condition
      if v_valid
        reconstruction_possible = true
        best_valid_one_tree = best_one_tree
        best_valid_π = π
      end

    end


    ### CRITÈRE ARRÊT

    # CRITÈRE ARRÊT
    if stop_criterion == "sub_gradient"
      if v == zeros(n)
        sub_gradient_null = true
        tour_obtained = true
        best_one_tree = one_tree
        best_valid_one_tree = best_one_tree
        best_valid_π = π
        break
      end

    # CRITÈRE ARRÊT sur le pas
    elseif stop_criterion == "t_step"
      
      # Condition arrêt
      #if t <= 10*eps(Float64) 
      if t <= 10^(-10)
        step_size_min_obtained = true
        break
      end
      
    # CRITÈRE ARRÊT sur la période
    elseif stop_criterion == "period_length"
      #println(period_length)
      # Condition arrêt
      if period_length == 0
        period_size_min_obtained = true
        break
      end

    end
    
  
    ### Choix d'une taille de pas

    # Fin de la période 
    if period_counter >= period_length # t=cte tant est aussi longtemps que period_counter=period_length
      # On remet le compteur à 0 qu'il y ait une amélioration ou pas : NOTE on l'incrémente à la fin, donc il commence à 0 
      period_counter = -1
      
      # Si pas d'amélioration à la dernière itération, on divise la taille de la période et t
      if w <= w_prev  
        period_length = fld(period_length,2) # ou τ
        t /= τ
        if first_period_exception
          first_period_exception = false
        end
      else 
        period_length = 2*period_length
      end

    end
  
    # Cas de la première période sans échec
    if first_period_exception
      if w > w_prev  # Si amélioration, on grandit t
        t *= τ
      else
        first_period_exception = false
      end
    end  
    
    # Mise à jour de k et de la période
    period_counter += 1
    k += 1

    #println("iteration :", k , " period : ", period_length, " t ", t , " grand W: ", W)
  end


  ### Sorti et post-processing 

  # Verification pour critere sur le pas et sur la période qu'une tournée a été obtenue
  if !sub_gradient_null
    tour_obtained = (get_degrees(best_valid_one_tree) .- 2 == zeros(n))
  end


  # POST-PROCESSING : du meilleur 1-tree valide (comportant seulement des degrés ∈ {-1,-0,1} ), qui n'est pas une tournée
  if !(tour_obtained)
    
    # Si possibilité de post-processing le 1-tree pour obtenir une approximation de la tournée
    if reconstruction_possible
      post_process_one_tree!(best_valid_one_tree, graph)
      tour_obtained_with_reconstruction = (get_degrees(best_valid_one_tree) .- 2 == zeros(n))
      
    end

  end

  # On retrouve les edges du graph initial
  """
  tour_edges = Edge{T}[]
  for edge_graph in get_edges(graph)
    for edge_tour in get_edges(best_valid_one_tree)
      if (get_node1(edge_graph)==get_node1(edge_tour)) && (get_node2(edge_graph)==get_node2(edge_tour))
        push!(tour_edges, edge_graph)
      end
    end
  end
  

  final_cost = 0.0
  for edge in tour_edges
      final_cost += get_weight(edge)
  end

  tour_graph = Graph("tour", get_nodes(graph), tour_edges)
  return tour_graph, final_cost, tour_obtained, tour_obtained_with_reconstruction
  """


  tour_edges = Edge{T}[]
  final_cost = 0.0
  for edge in get_edges(best_valid_one_tree)
      cost_edge = get_weight(edge) - ( best_valid_π[get_index(get_node1(edge))] + best_valid_π[get_index(get_node2(edge))] )
      set_weight!(edge, cost_edge)
      push!(tour_edges, edge)
      final_cost += cost_edge
  end
  tour_graph = Graph("tour", get_nodes(graph), tour_edges)

  return best_valid_one_tree, final_cost, tour_obtained, tour_obtained_with_reconstruction


end


""" Fonction utilité sur les degrées du vecteur v """
function v_score(v::Vector{Float64})
  number_of_ones = 0
  valid = true
  for i = 1:length(v)
    if abs(v[i])>1
      valid = false
      return valid, number_of_ones
    elseif abs(v[i])==1
      number_of_ones += 1
    end
  end
  return valid, number_of_ones
end