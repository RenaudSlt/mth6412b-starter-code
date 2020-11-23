include("graph.jl")
include("node.jl")
include("nodetree.jl")
include("markednode.jl")
include("edge.jl")
include("prim_algorithm.jl")
include("kruskal_algorithm.jl")


""" Algorithme de HK : basé sur les [1] [2] et [3]
  Input :
    1) graph : un graph complet
    2) algo_MST : un choix d'algorithme pour une sub-routine qui détermine un arbre de recouvrement minimal (MST). Entrée valide : "prim" ou "kruskal"
    3) source : un noeud source rattaché à graph. Ce noeud est utilisé pour la sub-routine MST. 
    4) initial_step_size : un pas initial pour l'algorithme, qui est basée sur une recherche directe
    5) stop_criterion : un critère d'arrêt basé sur soit le pas ("step_size"), la période ("period_length") ou le sub-gradient ("sub_gradient")
  Output:
    1) best_valid_one_tree : retourne le meilleur 1-tree. 
    2) final_cost : la sommes des arêtes, qui appartiennent à 1), du graph initial  
    3) tour_obtained : booléen qui indique si une tournée a été obtenue
    4) tour_obtained_with_reconstruction : booléen qui indique si une tournée a été obtenue, mais à l'aide d'une étape de reconstruction***
    5) max_iteration_obtained : booléen qui indique si le maximum d'itération laissez a été atteint

    ***L'étape de post-processing reconstruit un 1-tree qui n'est pas une tournée, mais contient seulement des noeuds avec des degrés qui sont soit {-1,0,1}
       (voir fonction post_process_one_tree! dans le fichier graph.jl)

    [1] : The Traveling-Salesman Problem and Minimum Spanning Trees (Held et Karp)
    [2] : The Traveling-Salesman Problem and Minimum Spanning Trees: Part II (Held et Karp)
    [3] : An Effective Implementation of the Lin-Kernighan Traveling Salesman Heuristic (Helsgaun)
    N.B. : la principale inspiration provient du papier [3]
"""
function hk_algorithm(graph::Graph{T}, algo_MST::String, source::Node{T}=get_nodes(graph)[1], initial_step_size::Float64=1.0, stop_criterion::String="t_step") where T

  # On vérifie que les arguments de type String sont corrects
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
  best_π = zeros(n)
  v = zeros(n)
  v_prev = zeros(n)
  best_v = zeros(n)
  w = 0
  W = -Inf
  
  # Initialisation pour le pas et la période
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

  # Flag pour signaliser qu'aucune convergence est atteinte après un certain nombre d'itération
  max_iteration_obtained = false

  # Flag pour gérer les cas pathologiques qui ne convergent pas
  at_least_one_imporvement = false

  # Initialisation des copies profonds pour ne pas modifier le graph passer en argument
  graph_copy = deepcopy(graph)
  best_one_tree = deepcopy(graph) 
  best_valid_one_tree = deepcopy(graph)
  one_tree = deepcopy(graph)

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

    ### Heuristique article [3]
    
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

      at_least_one_imporvement = true
      best_one_tree = one_tree
      best_π = π

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

    # Critère d'arrêt sur le sub-gradient
    if stop_criterion == "sub_gradient"

      # Condition d'arrêt
      if v == zeros(n)
        sub_gradient_null = true
        tour_obtained = true
        best_one_tree = one_tree
        best_valid_one_tree = best_one_tree
        best_valid_π = π
        break
      end

    # Critère d'arrêt sur le pas
    elseif stop_criterion == "t_step"
      
      # Condition arrêt
      if t <= 10^(-10)
        step_size_min_obtained = true
        break
      end
      
    # Critère d'arrêt sur la période
    elseif stop_criterion == "period_length"
      
      # Condition arrêt
      if period_length == 0
        period_size_min_obtained = true
        break
      end

    end
    
    # Condition d'arrêt spécial sur le nombre d'itération
    if k >= 100000
      max_iteration_obtained = true
      break
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

      # Si amélioration on double la période
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
  end


  ### Sorti et post-processing 
  
  # On retrouve les coûts initiaux
  for edge in get_edges(best_valid_one_tree)
    cost_edge = get_weight(edge) - ( best_valid_π[get_index(get_node1(edge))] + best_valid_π[get_index(get_node2(edge))] )
    set_weight!(edge, cost_edge)
  end

  # Verification pour critère sur le pas et sur la période qu'une tournée a été obtenue
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

  # On calcul le coût de la tournée ou du 1-tree
  final_cost = 0.0

  if tour_obtained || tour_obtained_with_reconstruction || reconstruction_possible
    for edge in get_edges(best_valid_one_tree)
      final_cost += get_weight(edge)
    end

    return best_valid_one_tree, final_cost, tour_obtained, tour_obtained_with_reconstruction, max_iteration_obtained, at_least_one_imporvement
  
  elseif at_least_one_imporvement

    for edge in get_edges(best_one_tree)
      cost_edge = get_weight(edge) - ( best_π[get_index(get_node1(edge))] + best_π[get_index(get_node2(edge))] )
      set_weight!(edge, cost_edge)
    end

    for edge in get_edges(best_one_tree)
      final_cost += get_weight(edge)
    end

    return best_one_tree, final_cost, tour_obtained, tour_obtained_with_reconstruction, max_iteration_obtained, at_least_one_imporvement

  else 
    for edge in get_edges(one_tree)
      final_cost += get_weight(edge)
    end
    return one_tree, final_cost, tour_obtained, tour_obtained_with_reconstruction, max_iteration_obtained, at_least_one_imporvement
  end



end


""" Fonction utilité pour la reconstruction en post-processing 
    -On calcule le degré du vecteur v et on retourne si aucun noeud, en absolu, a un degré supérieur à 1. 
    Input:
      -vecteur v de l'algorithme HK
    Output:
      -valid : vrai si si aucun noeud, en absolu, a un degré supérieur à 1
      -number_of ones : le nombre de 1

"""
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